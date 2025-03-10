@tool
class_name OISColliderRaycast3D
extends OISCollider

@export var raycast_length : float = 1.0
@export var laser_thickness : float = 0.002

@onready var raycast_mesh = preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/misc-resources/collider_raycast_mesh.tres")

var raycast_3d := RayCast3D.new()
var raycast_laser := MeshInstance3D.new()

var collision_object : Variant = null


func _ready() -> void:
	super()
	
	if Engine.is_editor_hint() and not (has_node("Raycast3D") and has_node("Laser")):
		raycast_3d.name = "Raycast3D"
		raycast_3d.collide_with_areas = true
		raycast_3d.collide_with_bodies = true
		raycast_3d.collision_mask = ois_collision_layer
		raycast_laser.name = "Laser"
		raycast_laser.mesh = raycast_mesh
		add_child(raycast_3d)
		add_child(raycast_laser)
		raycast_3d.owner = get_tree().edited_scene_root
		raycast_laser.owner = get_tree().edited_scene_root
	
	if not Engine.is_editor_hint():
		raycast_3d = get_node("Raycast3D")
		raycast_laser = get_node("Laser")
		raycast_3d.collision_mask = ois_collision_layer
		raycast_3d.collide_with_areas = true
		raycast_3d.collide_with_bodies = true
	
	
	#if raycast_3d != null and raycast_laser != null:
		#set_raycast_size(raycast_length, laser_thickness)
	
	show_raycast(false)


func set_raycast_size(ray_len, laser_thick):
	raycast_3d.target_position.x = 0
	raycast_3d.target_position.y = 0
	raycast_3d.target_position.z = -raycast_length
	raycast_laser.mesh.size = Vector3(laser_thick, laser_thick, ray_len)
	raycast_laser.position.z = -(ray_len/2)


func show_raycast(b : bool) -> void:
	raycast_laser.visible = b


func collider_enabled(b: bool) -> void:
	raycast_3d.enabled = b
	show_raycast(b)
	raycast_3d.collision_mask = ois_collision_layer


func _process(delta: float) -> void:
	if Engine.is_editor_hint() and (has_node("Raycast3D") and has_node("Laser")):
		raycast_3d = get_node("Raycast3D")
		raycast_laser = get_node("Laser")
		set_raycast_size(raycast_length, laser_thickness)


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if raycast_3d.is_colliding():
			if collision_object == null:
				collision_object = raycast_3d.get_collider()
				if is_instance_valid(collision_object):
					show_raycast(true)
					if not collision_object.is_in_group(get_parent().receiver_group):
						raycast_3d.add_exception(collision_object)
					else:
						body_entered.emit(collision_object)
		else:
			if collision_object != null:
				body_exited.emit(collision_object)
				collision_object = null
				show_raycast(false)
