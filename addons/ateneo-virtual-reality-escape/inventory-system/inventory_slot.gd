@tool
class_name InventorySlot
extends Node3D

signal current_object_in_slot

@export var slot_enabled : bool = true
@export var snap_zone_radius : float = 0.2
@export var default_object : NodePath
@export var group_required : String

@export var current_object : Node3D

@export_subgroup("Related Nodes")
@export var snap_zone := Area3D.new()
@export var collision_shape_3d := CollisionShape3D.new()
@export var mesh_shape_test := MeshInstance3D.new()
@export var audio_stream_player_3d := AudioStreamPlayer3D.new()
@export var slot_material_override = preload("res://addons/ateneo-virtual-reality-escape/inventory-system/inventory_slot_shader_a.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var new_shape = SphereShape3D.new()
	new_shape.radius = snap_zone_radius
	collision_shape_3d.shape = new_shape
	
	# Setting collision masks and layers for the Area3D
	
	snap_zone.set_collision_layer_value(1,false)
	snap_zone.set_collision_mask_value(1,false)
	snap_zone.set_collision_layer_value(3,true)
	snap_zone.set_collision_mask_value(3,true)
	snap_zone.set_collision_mask_value(17,true)
	snap_zone.set_collision_mask_value(30,true)
	
	var new_test_mesh = SphereMesh.new()
	new_test_mesh.radius = snap_zone_radius
	new_test_mesh.height = snap_zone_radius * 2
	
	# Temporary debug mesh to view range.
	mesh_shape_test.mesh = new_test_mesh
	mesh_shape_test.set_surface_override_material(0,slot_material_override)
	
	if Engine.is_editor_hint():
		snap_zone.name = "Area3D"
		collision_shape_3d.name = "CollisionShape3D"
		mesh_shape_test.name = "MeshInstance3D"
		audio_stream_player_3d.name = "AudioStreamPlayer3D"
		
		add_child(snap_zone)
		add_child(mesh_shape_test)
		snap_zone.add_child(collision_shape_3d)
		snap_zone.add_child(audio_stream_player_3d)
		
		snap_zone.owner = get_tree().edited_scene_root
		collision_shape_3d.owner = get_tree().edited_scene_root
		mesh_shape_test.owner = get_tree().edited_scene_root
		audio_stream_player_3d.owner = get_tree().edited_scene_root
	
	snap_zone.set_script(XRToolsSnapZone)
	
	if not Engine.is_editor_hint():
		
		snap_zone.grab_distance = snap_zone_radius
		snap_zone.enabled = slot_enabled
		
		snap_zone.body_entered.connect(snap_zone._on_snap_zone_body_entered)
		snap_zone.body_exited.connect(snap_zone._on_snap_zone_body_exited)
		
		# For debugging
		#snap_zone.body_entered.connect(_body_entered_area)
		#snap_zone.body_exited.connect(_body_exited_area)
		
		snap_zone.has_picked_up.connect(_set_current_slot_object)
		snap_zone.has_dropped.connect(_drop_current_slot_object)
		
		snap_zone.initial_object = default_object
		snap_zone.snap_require = group_required
		

func _set_current_slot_object(what) -> void:
	current_object = what
	print("===== Slot "+self.name+" has picked up object "+what.name+".")
	
func _drop_current_slot_object() -> void:
	current_object = null
	print("===== Slot "+self.name+" has dropped an object.")

func _body_entered_area(body) -> void:
	print("===== Body "+body.name+" has entered "+self.name+".")
	
func _body_exited_area(body) -> void:
	print("===== Body "+body.name+" has exited "+self.name+".")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This Node's CollisionShape3D requires a Shape")

	# Return warnings
	return warnings
	

	
