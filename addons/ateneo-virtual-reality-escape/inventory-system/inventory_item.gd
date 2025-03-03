@tool
class_name InventoryItem
extends Node3D

# Can set to override these meshes if they pose a problem.
@export var defined_mesh : Node3D
@export var defined_collision_shape : CollisionShape3D

var preserved_mesh_scale : Vector3
var preserved_collider_scale : Vector3

@export var preferred_scale : float = 0.5
@export var object_transform_adjustment : Vector3
@export var object_rotation_adjustment : Vector3

var is_resized : bool
var body_collision_detected : bool
var slot_interaction_detected : bool
var is_in_slot : bool

var is_colliding_with : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for object in get_parent().get_children():
		if defined_mesh != null and defined_collision_shape != null:
			preserved_mesh_scale = defined_mesh.scale
			preserved_collider_scale = defined_collision_shape.scale
			break
		
		if object is not XRToolsGrabPointHand and OISActorComponent:
			if object is CollisionShape3D:
				defined_collision_shape = object
			elif object is Node3D or MeshInstance3D:
				defined_mesh = object
				
func _process(delta):
	if body_collision_detected:
		_resize_mesh(preferred_scale)
		body_collision_detected = false
	
	if slot_interaction_detected:
		if is_in_slot:
			_on_in_slot_transform()
		else:
			_on_out_slot_transform()
		slot_interaction_detected = false
			
	
func _resize_mesh(scalex):
	if is_colliding_with.size() == 0:
		var tween = get_tree().create_tween()
		tween.tween_property(defined_mesh, "scale", preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "scale", preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		is_resized = false
		await tween.finished
	elif is_colliding_with.size() >= 1:
		var tween = get_tree().create_tween()
		tween.tween_property(defined_mesh, "scale", scalex*preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "scale", preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		is_resized = true
		await tween.finished

func _on_out_slot_transform():
	print("OUT SLOT TRANSFORM CALLED ASDJKASDJKLASDKJADS")
	defined_mesh.position = Vector3(0,0,0)
	defined_mesh.rotation_degrees = Vector3(0,180,0)
	
	defined_collision_shape.position = Vector3(0,0,0)
	defined_collision_shape.rotation_degrees = Vector3(0,180,0)

func _on_in_slot_transform():
	print("IN SLOT TRANSFORM CALLED ASDJKASDJKLASDKJADS")
	defined_mesh.position = object_transform_adjustment
	defined_mesh.rotation_degrees = object_rotation_adjustment
	
	defined_collision_shape.position = object_transform_adjustment
	defined_collision_shape.rotation_degrees = object_rotation_adjustment

	
	
