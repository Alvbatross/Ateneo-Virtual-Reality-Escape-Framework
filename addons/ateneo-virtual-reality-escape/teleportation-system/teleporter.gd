@tool
class_name Teleporter
extends Node3D

@export var teleporter_name : String: 
	set(tp_name):
		if tp_name != teleporter_name:
			teleporter_name = tp_name
			_update_teleporter_name()

@export var teleporter_enabled : bool
@export var teleporter_active : bool = true
@export var teleporter_position : Vector3
@export var teleporter_rotation : Vector3
@export var connected_teleporters : Array[Teleporter]


# Not relative to the teleporter's position! This is global!
@export var spectator_camera_position : Vector3
@export var spectator_camera_rotation : Vector3

# Plans to allow users to add their own custom scene for teleporters soon.

var default_teleporter_mesh := MeshInstance3D.new()
var default_mesh_shape := CylinderMesh.new()

var default_teleporter_arrow := MeshInstance3D.new()
var arrow_mesh := PrismMesh.new()

var default_static_body := StaticBody3D.new()
var default_collider := CollisionShape3D.new()
var default_collider_shape := CylinderShape3D.new()

var teleporter_material_override = StandardMaterial3D.new()

var current_teleporter : bool
var aimed_at : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_up_teleporter_mesh()
	
	if self.name != teleporter_name:
		teleporter_name = self.name
	
	if not Engine.is_editor_hint():	
		teleporter_position = self.position
		teleporter_rotation = self.rotation_degrees

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		teleporter_position = self.position
		teleporter_rotation = self.rotation_degrees
	
	_update_teleporter_state()

# Set parameters for the default teleporter mesh here.
func _set_up_teleporter_mesh() -> void:
	default_mesh_shape.bottom_radius = 0.4
	default_mesh_shape.top_radius = 0.4
	default_mesh_shape.height = 0.05
	default_teleporter_mesh.mesh = default_mesh_shape
	default_teleporter_mesh.set_surface_override_material(0,teleporter_material_override)
	
	arrow_mesh.size = Vector3(0.05,0.05,0.05)
	default_teleporter_arrow.mesh = arrow_mesh
	default_teleporter_arrow.position.z = -0.25
	default_teleporter_arrow.rotation_degrees.x = -90
	default_teleporter_arrow.set_surface_override_material(0,teleporter_material_override)
	
	default_collider.shape = default_collider_shape
	default_collider_shape.height = 0.05
	default_collider_shape.radius = 0.4
	
	# Set collision layer for FunctionPointer.
	default_static_body.set_collision_layer_value(21,true)
	
	add_child(default_static_body)
	default_static_body.add_child(default_collider)
	
	add_child(default_teleporter_mesh)
	default_teleporter_mesh.add_child(default_teleporter_arrow)
	
func _update_teleporter_name() -> void:
	if teleporter_name != "":
		self.name = teleporter_name
	else:
		self.name = "Teleporter"
		
func _update_teleporter_state() -> void:
	default_teleporter_mesh.get_surface_override_material(0).shading_mode = 0
	default_teleporter_arrow.get_surface_override_material(0).shading_mode = 0
	
	if !teleporter_enabled and not current_teleporter:
		default_teleporter_mesh.get_surface_override_material(0).albedo_color = Color(0.125,0.125,0.125)
		default_teleporter_arrow.get_surface_override_material(0).albedo_color = Color(0.125,0.125,0.125)
	elif teleporter_enabled and not current_teleporter and aimed_at: 
		default_teleporter_mesh.get_surface_override_material(0).albedo_color = Color(1,0.5,1)
		default_teleporter_arrow.get_surface_override_material(0).albedo_color = Color(1,0.5,1)
	elif teleporter_enabled and not current_teleporter and not aimed_at:
		default_teleporter_mesh.get_surface_override_material(0).albedo_color = Color(1,1,1)
		default_teleporter_arrow.get_surface_override_material(0).albedo_color = Color(1,1,1)
	elif current_teleporter:
		default_teleporter_mesh.get_surface_override_material(0).albedo_color = Color(0.5,1,1)
		default_teleporter_arrow.get_surface_override_material(0).albedo_color = Color(0.5,1,1)
		
func _update_connections() -> void:
	if connected_teleporters.size() != 0:
		for teleporters in connected_teleporters:
			if !teleporters.connected_teleporters.has(self):
				teleporters.connected_teleporters.append(self)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_parent().name != "TeleporterManager":
		warnings.append("This Teleporter is not a child of a TeleporterManager. Please ensure that this teleporter is a child of a TeleporterManager.")
	
	if self.name == "Teleporter" or teleporter_name == "":
		warnings.append("This Teleporter does not have a name set. Please set a name for this teleporter.")
		
	if connected_teleporters.size() < 1:
		warnings.append("This Teleporter is not connected to any other teleporter.")

	# Return warnings
	return warnings
