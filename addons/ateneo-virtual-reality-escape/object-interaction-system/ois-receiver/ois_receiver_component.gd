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

@export var group : String = ""

@export var requirement : float

@export var snap_actor : bool = false

@export var trigger_action : bool = false

@export_flags_3d_physics var ois_collision_layer : int = COLLISION_LAYER

var completed : bool = false

var interacting_object
var total_progress : float = 0
var rate : float = 0

var area_3d := Area3D.new()
var collision_shape_3d := CollisionShape3D.new()

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
		add_to_group(group)
		area_3d.add_to_group(group)





func initialize_action_vars():
	pass


func start_action_check(actor : OISActorComponent) -> void:
	action_started.emit(requirement, total_progress)
	interacting_object = actor.get_parent()
	rate = actor.get_actor_rate()
	initialize_action_vars()


func end_action() -> void:
	action_ended.emit(requirement, total_progress)


func action_ongoing(delta: float) -> void:
	action_in_progress.emit(requirement, total_progress)
	check_if_completed()


func check_if_completed():
	if not completed:
		if (requirement > 0 and total_progress >= requirement or requirement < 0 and total_progress <= requirement):
			print("Action completed check.")
			action_completed.emit(requirement, total_progress)
			completed = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This node's CollisionShape3D requires a Shape")
	
	if snap_actor:
		warnings.append("If Snap Actor is on, this node requires a Snap Position")
	# Return warnings
	return warnings
