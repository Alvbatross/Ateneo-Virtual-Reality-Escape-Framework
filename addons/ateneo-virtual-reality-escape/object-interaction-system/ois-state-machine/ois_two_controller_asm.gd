@tool
class_name OISTwoControllerASM
extends OISActorStateMachine


@export var left_hand_state_machine : NodePath
@export var right_hand_state_machine : NodePath
@export_category("Two Controller Settings")
## If on, action will only be done if both controllers are active
@export var require_both_controllers : bool = false

var left_hand_asm : OISSingleControllerASM
var right_hand_asm : OISSingleControllerASM

var idle_state : ControllerIdleState
var active_state : ControllerActiveState
var one_active_colliding 
var two_active_colliding


func initialize() -> void:
	left_hand_asm = get_node_or_null(left_hand_state_machine)
	right_hand_asm = get_node_or_null(right_hand_state_machine)
	
	#idle_state = ControllerIdleState.new()
	#idle_state.name = "IdleState"
	#add_child(idle_state)
	#
	#active_state = ControllerActiveState.new()
	#active_state.name = "ActiveState"
	#add_child(active_state)
	#
	#active_colliding_state = ActiveCollidingState.new()
	#active_colliding_state.name = "ActiveCollidingState"
	#add_child(active_colliding_state)
	#
	#controller = get_actor_component().get_actor()
	#
	#state = active_state
	#
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
