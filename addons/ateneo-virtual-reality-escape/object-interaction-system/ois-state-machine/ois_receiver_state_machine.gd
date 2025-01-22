@tool
class_name OISReceiverStateMachine
extends OIS

signal transitioned(state_name)

@export var initial_state: NodePath

@onready var receiver : OISReceiverComponent = get_parent()

var state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await owner.ready
	
	initialize_states()
	
	for child in get_children():
		await child.ready
		child._ois_actor_state_machine = self
	
	state.enter_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.update(delta)
		print(state.name)


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


func initialize_states() -> void:
	state = get_node(initial_state)


func get_receiver() -> OISReceiverComponent:
	return receiver


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if not get_parent() is OISReceiverComponent:
		warnings.append("This OISReceiverStateMachine needs an OISReceiverComponent as a Parent")
	
	if get_child_count() <= 0:
		warnings.append("This OISReceiverStateMachine has no States, Please include an OISReceiverState")
	
	for child in get_children():
		if not child is OISActorState:
			warnings.append(child.name + " is NOT a valid OISReceiverState")

	# Return warnings
	return warnings
