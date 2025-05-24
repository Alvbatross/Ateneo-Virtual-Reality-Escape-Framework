@tool
class_name OISReceiverComponent
extends OIS


## Emitted the moment an OIS action is performed on a Receiver
signal action_started(requirement, total_progress)
## Emitted every frame during an OIS action
signal action_in_progress(requirement, total_progress)
## Emitted the moment an OIS action ends. Doesn't necessarily mean when an OIS action is completed
signal action_ended(requirement, total_progress)
## Emitted the moment the receiver's action requirement is met.
signal action_completed(requirement, total_progress)

## The receiver group of the object. Should be the same as the receiver_group in the Actor
@export var group : String = ""
## The requirement for the Action
@export var requirement : float
## Boolean to determine whether or not the actor will snap to the receiver's position
@export var snap_actor : bool = false

@export var reset_progress : bool = false

@export var oneshot : bool = true

@export var receive_from_self : bool = false

@export_flags_3d_physics var ois_collision_layer : int = COLLISION_LAYER

var completed : bool = false

var interacting_object
var interacting_actor : OISActorComponent
var total_progress : float = 0
var rate : float = 0

var area_3d := Area3D.new()
var collision_shape_3d := CollisionShape3D.new()
var marker_3d : Marker3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint() and not has_node("Area3D"):
		area_3d.name = "Area3D"
		collision_shape_3d.name = "CollisionShape3D"
		area_3d.collision_layer = ois_collision_layer
		area_3d.collision_mask = ois_collision_layer
		add_child(area_3d)
		area_3d.add_child(collision_shape_3d)
		area_3d.owner = get_tree().edited_scene_root
		collision_shape_3d.owner = get_tree().edited_scene_root
		
	if not Engine.is_editor_hint():
		area_3d = get_node("Area3D")
		area_3d.collision_layer = ois_collision_layer
		area_3d.collision_mask = ois_collision_layer
		add_to_group(group)
		area_3d.add_to_group(group)
		if snap_actor:
			for child in get_children():
				if child is Marker3D:
					marker_3d = child
					break


func initialize_action_vars() -> void:
	pass


func start_action_check(actor : OISActorComponent, rate_mult: float) -> void:
	if actor.get_actor() == get_parent() and not receive_from_self:
		print("I Am Receiving Myself")
		return
	
	action_started.emit(requirement, total_progress)
	interacting_object = actor.get_parent()
	interacting_actor = actor
	rate = actor.get_actor_rate() * rate_mult
	initialize_action_vars()


func end_action() -> void:
	action_ended.emit(requirement, total_progress)
	if reset_progress:
		print("Resetting Progress")
		total_progress = 0
	if not oneshot:
		print("Resetting Receiver Completion")
		completed = false


func action_ongoing(delta: float) -> void:
	action_in_progress.emit(requirement, total_progress)
	check_if_completed()


func check_if_completed() -> void:
	if not completed:
		if (requirement > 0 and total_progress >= requirement or requirement < 0 and total_progress <= requirement):
			print("Action completed check.")
			action_completed.emit(requirement, total_progress)
			completed = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This node's CollisionShape3D requires a Shape")
	
	if snap_actor and not has_snap_marker():
		warnings.append("If Snap Actor is on, this node requires a Marker3D as a Snapping Position")
	
	# Return warnings
	return warnings


func has_snap_marker() -> bool:
	for child in get_children():
		if child is Marker3D:
			return true
	
	return false
