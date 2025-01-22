@tool
class_name OISReceiverComponent
extends OIS


signal action_started(requirement, total_progress)
signal action_in_progress(requirement, total_progress)
signal action_ended(requirement, total_progress)
signal action_completed(requirement, total_progress)

@export var requirement : float

var interacting_object
var total_progress : float = 0
var rate : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
