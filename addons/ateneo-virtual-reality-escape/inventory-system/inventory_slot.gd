@tool
class_name InventorySlot
extends Node3D

signal current_object_in_slot

@export var slot_enabled : bool = true
@export var snap_zone_radius : float = 0.2
@export var default_object : NodePath
@export var group_required : String
@export var slot_material_override = preload("res://addons/ateneo-virtual-reality-escape/inventory-system/misc-resources/inventory_slot_shader_a.tres")


var snap_zone_mesh := MeshInstance3D.new()
var mesh_shape := SphereMesh.new()
var snap_zone_scene := preload("res://addons/godot-xr-tools/objects/snap_zone.tscn")

var snap_zone : XRToolsSnapZone
var current_object : Node3D

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

	
	if not Engine.is_editor_hint():
		snap_zone = get_node("SnapZone")
		snap_zone_mesh = get_node("MeshInstance3D")
		# For debugging
		snap_zone.body_entered.connect(_body_entered_area)
		snap_zone.body_exited.connect(_body_exited_area)
		
		snap_zone.has_picked_up.connect(_set_current_slot_object)
		snap_zone.has_dropped.connect(_drop_current_slot_object)
		
		snap_zone.initial_object = default_object
		snap_zone.snap_require = group_required


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if is_instance_valid(snap_zone):
			snap_zone.grab_distance = snap_zone_radius
		if is_instance_valid(snap_zone_mesh):
			mesh_shape.radius = snap_zone_radius
			mesh_shape.height = snap_zone_radius * 2
			snap_zone_mesh.mesh = mesh_shape
		

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

	# Return warnings
	return warnings
	

	
