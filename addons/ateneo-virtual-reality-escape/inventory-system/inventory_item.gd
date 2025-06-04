@tool
class_name InventoryItem
extends Node3D

# Allow setting if the item is unique (only one of this item can exist at any given time).
@export var unique : bool

# Can set to override these meshes if they pose a problem.
@export var defined_mesh : Node3D
@export var defined_collision_shape : CollisionShape3D

var preserved_mesh_scale : Vector3
var preserved_collider_scale : Vector3

var preserved_mesh_transform : Vector3
var preserved_collider_transform : Vector3

var preserved_mesh_rotation : Vector3
var preserved_collider_rotation : Vector3

@export var preferred_scale : float = 0.5
@export var object_transform_adjustment : Vector3
@export var object_rotation_adjustment : Vector3

@export var additional_mesh : Node3D
@export var exclude_additional_mesh_transform: bool

@export var has_custom_shrink_position : bool = false
@export var grab_point_right : Node3D
@export var grab_point_left : Node3D


var addt_preserved_mesh_scale : Vector3
var addt_preserved_mesh_transform : Vector3
var addt_preserved_mesh_rotation : Vector3

var is_resized : bool
var body_collision_detected : bool
var slot_interaction_detected : bool
var is_in_slot : bool
var is_grabbed : bool
var is_colliding_with : Array

var shrink_position : Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preserved_mesh_scale = defined_mesh.scale
	preserved_collider_scale = defined_collision_shape.scale
			
	preserved_mesh_transform = defined_mesh.position
	preserved_collider_transform = defined_collision_shape.position
			
	preserved_mesh_rotation = defined_mesh.rotation_degrees
	preserved_collider_rotation = defined_collision_shape.rotation_degrees
	
	if additional_mesh != null:
		addt_preserved_mesh_scale = additional_mesh.scale
		addt_preserved_mesh_transform = additional_mesh.position
		addt_preserved_mesh_rotation = additional_mesh.rotation
	
	if is_instance_valid(get_parent()):
		if get_parent() is XRToolsPickable:
			get_parent().grabbed.connect(_grabbed)
			get_parent().released.connect(_released)
			
	is_grabbed = false
				
func _process(delta):
	if body_collision_detected:
		if is_grabbed:
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
		tween.set_parallel(true)
		tween.tween_property(defined_mesh, "scale", preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "scale", preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_mesh, "position", preserved_mesh_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "position", preserved_collider_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		if is_instance_valid(additional_mesh):
			tween.tween_property(additional_mesh, "scale", addt_preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(additional_mesh, "position", addt_preserved_mesh_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		is_resized = false
	elif is_colliding_with.size() >= 1:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(defined_mesh, "scale", scalex*preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "scale", scalex*preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_mesh, "position", shrink_position, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(defined_collision_shape, "position", shrink_position, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		if is_instance_valid(additional_mesh):
			tween.tween_property(additional_mesh, "scale", scalex*addt_preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(additional_mesh, "position", scalex*addt_preserved_mesh_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		is_resized = true

func _on_out_slot_transform():
	defined_mesh.position = preserved_mesh_transform
	defined_mesh.rotation_degrees = preserved_mesh_rotation
	
	defined_collision_shape.position = preserved_collider_transform
	defined_collision_shape.rotation_degrees = preserved_collider_rotation
	
	if is_instance_valid(additional_mesh) and !exclude_additional_mesh_transform:
		additional_mesh.position = addt_preserved_mesh_transform
		additional_mesh.rotation_degrees = preserved_mesh_rotation
	

func _on_in_slot_transform():
	defined_mesh.position = object_transform_adjustment
	defined_mesh.rotation_degrees = object_rotation_adjustment
	
	defined_collision_shape.position = object_transform_adjustment
	defined_collision_shape.rotation_degrees = object_rotation_adjustment
	
	if is_instance_valid(additional_mesh) and !exclude_additional_mesh_transform:
		additional_mesh.rotation_degrees = object_rotation_adjustment
		additional_mesh.position += object_transform_adjustment

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check Actor Component if it has an OISActorStateMachine
	if defined_mesh == null:
		warnings.append("No defined mesh for InventoryItem.")
	
	if defined_collision_shape == null:
		warnings.append("No defined collision mesh for InventoryItem.")
		
	if not is_instance_valid(get_parent()) or get_parent() is not XRToolsPickable:
		warnings.append("Parent must be a XRToolsPickable node.")

	# Return warnings
	return warnings

func _force_enlarge_item():
	is_colliding_with.clear()
	is_grabbed = false
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(defined_mesh, "scale", preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(defined_collision_shape, "scale", preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	if is_instance_valid(additional_mesh):
		tween.tween_property(additional_mesh, "scale", addt_preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(additional_mesh, "position", addt_preserved_mesh_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	is_resized = false
	await tween.finished
	

func _force_shrink_item():
	var tween = get_tree().create_tween()
	is_grabbed = true
	tween.set_parallel(true)
	tween.tween_property(defined_mesh, "scale", preferred_scale*preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(defined_collision_shape, "scale", preferred_scale*preserved_collider_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	if is_instance_valid(additional_mesh):
		tween.tween_property(additional_mesh, "scale", preferred_scale*addt_preserved_mesh_scale, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(additional_mesh, "position", preferred_scale*addt_preserved_mesh_transform, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	is_resized = true
	await tween.finished
	
func _grabbed(pickable : Variant, by : Variant) -> void:
	if by is XRToolsFunctionPickup:
		is_grabbed = true
		if has_custom_shrink_position:
			if by.get_parent().has_node("RightHand"):
				shrink_position = grab_point_right.position
			if by.get_parent().has_node("LeftHand"):
				shrink_position = grab_point_left.position
	if by is XRToolsSnapZone:
		is_grabbed = false
		if has_custom_shrink_position:
			defined_mesh.position = preserved_mesh_transform
			defined_collision_shape.position = preserved_collider_transform
	
func _released(pickable : Variant, by : Variant) -> void:
	if by is XRToolsFunctionPickup:
		is_grabbed = false
		if has_custom_shrink_position:
			defined_mesh.position = preserved_mesh_transform
			defined_collision_shape.position = preserved_collider_transform
	
