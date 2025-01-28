@tool
class_name OISReceiverComponent
extends OIS


signal action_started(requirement, total_progress)
signal action_in_progress(requirement, total_progress)
signal action_ended(requirement, total_progress)
signal action_completed(requirement, total_progress)

@export var group : String = ""

@export var requirement : float

@export var snap_actor : bool = false

@export var trigger_action : bool = false

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
		add_child(area_3d)
		area_3d.add_child(collision_shape_3d)
		area_3d.owner = get_tree().edited_scene_root
		collision_shape_3d.owner = get_tree().edited_scene_root
		
	if not Engine.is_editor_hint():
		add_to_group(group)


func initialize_action_vars():
	pass

func start_action_check(actor : OISActorComponent) -> void:
	interacting_object = actor.get_parent()
	rate = actor.get_actor_rate()
	initialize_action_vars()


func action_ongoing(delta: float) -> void:
	action_in_progress.emit(requirement, total_progress)
	check_if_completed()


func check_if_completed():
	if (requirement > 0 && total_progress >= requirement || requirement < 0 && total_progress <= requirement):
		print("Action completed check.")
		action_completed.emit(requirement, total_progress)
		return true



func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This node's CollisionShape3D requires a Shape")

	# Return warnings
	return warnings
