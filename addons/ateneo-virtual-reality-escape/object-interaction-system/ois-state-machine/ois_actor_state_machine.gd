@tool
class_name OISActorStateMachine
extends OIS

signal transitioned(state_name)

@export var initial_state: NodePath

@onready var actor : OISActorComponent = get_parent()

@onready var state: OISActorState = get_node(initial_state)

var receiver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		child._ois_actor_state_machine = self
	
	state.enter_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.update(delta)


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.physics_update(delta)


func transition_to(target_state: String, msg: Dictionary = {}) -> void:
	var old_state: OISActorState = state
	var new_state: OISActorState
	
	if not has_node(target_state):
		return
	
	state.exit_state()
	state = get_node(target_state)
	new_state = state
	state.enter_state(msg)
	emit_signal("transitioned", state.name)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check Actor Component if it has an OISActorStateMachine
	for child in get_children():
		if !child.is_class("OISActorState"):
			warnings.append(child.name + " is NOT a valid OISActorState")

	# Return warnings
	return warnings
