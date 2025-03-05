@tool
class_name OISTwoControllerASM
extends OISActorStateMachine


@export var left_hand_state_machine : NodePath
@export var right_hand_state_machine : NodePath
@export_category("Two Controller Settings")
## If on, action will only be done if both controllers are active
@export var require_two_handed : bool = false

var left_hand_asm : OISSingleControllerASM
var right_hand_asm : OISSingleControllerASM

var idle_state : TwoControllerIdleState
var active_state : TwoControllerActiveState
var one_hand_active_colliding_state : OneHandActiveCollidingState
var two_hand_active_colliding_state : TwoHandActiveCollidingState

var active_controllers : Array = []


func initialize() -> void:
	left_hand_asm = get_node_or_null(left_hand_state_machine)
	right_hand_asm = get_node_or_null(right_hand_state_machine)
	
	idle_state = TwoControllerIdleState.new()
	idle_state.name = "IdleState"
	add_child(idle_state)
	
	active_state = TwoControllerActiveState.new()
	active_state.name = "ActiveState"
	add_child(active_state)
	
	one_hand_active_colliding_state = OneHandActiveCollidingState.new()
	one_hand_active_colliding_state.name = "OneHandActiveCollidingState"
	add_child(one_hand_active_colliding_state)
	
	two_hand_active_colliding_state = TwoHandActiveCollidingState.new()
	two_hand_active_colliding_state.name = "TwoHandActiveCollidingState"
	add_child(two_hand_active_colliding_state)
	
	active_controllers.append(left_hand_asm.controller)
	active_controllers.append(right_hand_asm.controller)
	
	state = active_state
	
	initialization_done = true


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if not get_parent() is OISActorComponent:
		warnings.append("This OISActorStateMachine needs an OISActorComponent as a Parent")
	
	if get_child_count() <= 0:
		warnings.append("This OISActorStateMachine has no States, Please include an OISActorState")
	
	for child in get_children():
		if not child is OISActorState:
			warnings.append(child.name + " is NOT a valid OISActorState")
	
	if left_hand_state_machine.is_empty() or right_hand_state_machine.is_empty():
		warnings.append("No Left and/or Right hand State Machines assigned. Both need to be assigned for this Node to work.")
		update_configuration_warnings()
	
	return warnings
