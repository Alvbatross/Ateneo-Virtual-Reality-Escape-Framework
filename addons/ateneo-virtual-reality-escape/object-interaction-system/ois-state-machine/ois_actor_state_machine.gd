@tool
class_name OISActorStateMachine
extends OIS
## This Node manages the States of an OIS Actor. Must be added as a child of an OISActorComponent

signal transitioned(state_name)

@export var initial_state: NodePath

@onready var actor : OISActorComponent = get_parent()

var state: OISActorState

var receiver

var controller : XRController3D

var initialization_done : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	
	initialize()
	
	for child in get_children():
		await child._ready
		child._ois_actor_state_machine = self
	
	state.enter_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not initialization_done:
			initialize()
	if not Engine.is_editor_hint():
		state.update(delta)


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state.physics_update(delta)


func handle_enter_collision(receiver) -> void:
	if not Engine.is_editor_hint():
		state._on_enter_collision(receiver)


func handle_exit_collision(receiver) -> void:
	if not Engine.is_editor_hint():
		state._on_exit_collision(receiver)

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


func initialize() -> void:
	state = get_node(initial_state)


func get_actor_component() -> OISActorComponent:
	return actor


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if not get_parent() is OISActorComponent:
		warnings.append("This OISActorStateMachine needs an OISActorComponent as a Parent")
	
	if get_child_count() <= 0:
		warnings.append("This OISActorStateMachine has no States, Please include an OISActorState")
	
	for child in get_children():
		if not child is OISActorState:
			warnings.append(child.name + " is NOT a valid OISActorState")

	# Return warnings
	return warnings
