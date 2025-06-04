@tool
class_name InventorySlot
extends Node3D

signal current_object_in_slot(object, row, col)
signal slot_picked_up
signal slot_dropped

@export var update_slot_settings : bool = false

@export var slot_enabled : bool = true
@export var snap_zone_radius : float = 0.2
@export var default_object : XRToolsPickable
@export var group_required : String
@export var funny_effect : bool
@export var ignore_inventory_item_scale : bool

@export var slot_material_override = preload("res://addons/ateneo-virtual-reality-escape/inventory-system/misc-resources/inventory_slot_shader_a.tres")

var snap_zone_mesh := MeshInstance3D.new()
var mesh_shape := SphereMesh.new()
var snap_zone_scene := preload("res://addons/godot-xr-tools/objects/snap_zone.tscn")

var snap_zone : XRToolsSnapZone
var current_object : Node3D
var is_parented : bool

func _ready() -> void:
	if Engine.is_editor_hint() and not has_node("SnapZone"):
		snap_zone = snap_zone_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		snap_zone.name = "SnapZone"
		snap_zone.grab_distance = snap_zone_radius
		snap_zone.enabled = slot_enabled
		add_child(snap_zone)
		snap_zone.owner = get_tree().edited_scene_root
		
		mesh_shape.radius = snap_zone_radius
		mesh_shape.height = snap_zone_radius * 2
		snap_zone_mesh.mesh = mesh_shape
		snap_zone_mesh.set_surface_override_material(0,slot_material_override)
		snap_zone_mesh.name = "MeshInstance3D"
		add_child(snap_zone_mesh)
		snap_zone_mesh.owner = get_tree().edited_scene_root
		
	if self.get_parent() is InventorySystem:
		if self.owner != null:
			is_parented = true
	else:
		if self.owner != null:
			print("[AVRE - Inventory] "+self.name+" is NOT parented to an Inventory System. Disregarding matrix placement options.")
			is_parented = false

	if not Engine.is_editor_hint():
		snap_zone = get_node("SnapZone")
		snap_zone_mesh = get_node("MeshInstance3D")
		
		if !is_instance_valid(snap_zone):
			self.queue_free()
	
		#For debugging
		snap_zone.body_entered.connect(_body_entered_area)
		snap_zone.body_exited.connect(_body_exited_area)
		
		snap_zone.has_picked_up.connect(_set_current_slot_object)
		snap_zone.has_dropped.connect(_drop_current_slot_object)
		
		#snap_zone.initial_object = default_object
		
		var reference_obj = default_object
		if is_instance_valid(reference_obj):
			call_deferred("_pick_up_object_init",reference_obj)
		
		snap_zone.snap_require = group_required
		#if funny_effect:
			#self.rotation_degrees.x += 90

func _physics_process(delta: float) -> void:
	if update_slot_settings and Engine.is_editor_hint() and has_node("SnapZone") and has_node("MeshInstance3D"):
		snap_zone = get_node("SnapZone")
		snap_zone_mesh = get_node("MeshInstance3D")
		snap_zone.grab_distance = snap_zone_radius
		mesh_shape.radius = snap_zone_radius
		mesh_shape.height = snap_zone_radius * 2
		snap_zone_mesh.mesh = mesh_shape
		snap_zone_mesh.set_surface_override_material(0,slot_material_override)
		update_slot_settings = false
	
	if funny_effect and not Engine.is_editor_hint():
		if self.rotation_degrees.y > 360:
			self.rotation_degrees.y = 0
		self.rotation_degrees.y += 1
	
	if not Engine.is_editor_hint():
		if is_parented:
			if !self.get_parent().visible:
				snap_zone.enabled = false
				if is_instance_valid(current_object):
					current_object.visible = false
					
			else:
				snap_zone.enabled = true
				if is_instance_valid(current_object):
					current_object.visible = true
				

		
func _set_current_slot_object(what) -> void:
	current_object = what
	if is_parented:
		var row_col_get = self.name.split("_")
		current_object_in_slot.emit(current_object, int(row_col_get[1]), int(row_col_get[2]))
		slot_picked_up.emit()
	else:
		current_object_in_slot.emit(current_object,0,0)
		slot_picked_up.emit()
	
	if is_instance_valid(current_object.get_node("InventoryItem")):
		current_object.get_node("InventoryItem").slot_interaction_detected = true
		current_object.get_node("InventoryItem").is_in_slot = true
	
	print("[AVRE - Inventory] Slot "+self.name+" has picked up object "+what.name+".")
	
func _drop_current_slot_object() -> void:
	if is_instance_valid(current_object.get_node("InventoryItem")):
		current_object.get_node("InventoryItem").slot_interaction_detected = true
		current_object.get_node("InventoryItem").is_in_slot = false
	
	current_object = null
	if is_parented:
		var row_col_get = self.name.split("_")
		current_object_in_slot.emit(current_object, int(row_col_get[1]), int(row_col_get[2]))
		slot_dropped.emit()
	else:
		current_object_in_slot.emit(current_object,0,0)
		slot_dropped.emit()
	
	print("[AVRE - Inventory] Slot "+self.name+" has dropped an object.")

func _body_entered_area(body) -> void:
	if current_object == null:
		if is_parented:
			if self.get_parent().visible and not ignore_inventory_item_scale:
				if is_instance_valid(body.get_node("InventoryItem")):
					body.get_node("InventoryItem").body_collision_detected = true
					body.get_node("InventoryItem").is_colliding_with.append(self)
		else:
			if self.visible and not ignore_inventory_item_scale:
				if is_instance_valid(body.get_node("InventoryItem")):
					body.get_node("InventoryItem").body_collision_detected = true
					body.get_node("InventoryItem").is_colliding_with.append(self)
			
func _body_exited_area(body) -> void:
	if is_instance_valid(body.get_node("InventoryItem")):
			if !snap_zone.has_snapped_object():
				if body.get_node("InventoryItem").is_colliding_with.has(self):
					body.get_node("InventoryItem").is_colliding_with.erase(self)
					body.get_node("InventoryItem").body_collision_detected = true
			
func _pick_up_object(body) -> void:
	# Ensure the object is picked up properly and scale is adjusted to fit the slot according to the InventoryItem specifications.
	snap_zone.pick_up_object(body)
	_body_entered_area(body)
	
func _pick_up_object_init(body) -> void:
	# Ensure the object is picked up properly and scale is adjusted to fit the slot according to the InventoryItem specifications.
	if is_instance_valid(body.get_node("InventoryItem")) and not ignore_inventory_item_scale:
		body.get_node("InventoryItem").call_deferred("_force_shrink_item")
	_body_entered_area(body)
	snap_zone.pick_up_object(body)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	# Return warnings
	return warnings
	

	
