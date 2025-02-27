@tool
class_name OISTwoHandToolASM
extends OISActorStateMachine

## If False, action will still work with one hand, but the action's effectiveness is lessened
@export var require_two_handed : bool = false

var idle_state : ToolIdleState
var one_hand_active_state : ToolOneHandActiveState
var two_hand_active_state : ToolTwoHandActiveState
var active_colliding_state : ActiveCollidingState

var active_controllers : Array = []

func initialize() -> void:
	idle_state = ToolIdleState.new()
	idle_state.name = "IdleState"
	add_child(idle_state)
	
	one_hand_active_state = ToolOneHandActiveState.new()
	one_hand_active_state.name = "OneHandActiveState"
	add_child(one_hand_active_state)
	
	two_hand_active_state = ToolTwoHandActiveState.new()
	two_hand_active_state.name = "TwoHandActiveState"
	add_child(two_hand_active_state)
	#active_colliding_state = ActiveCollidingState.new()
	#active_colliding_state.name = "ActiveCollidingState"
	#add_child(active_colliding_state)
	#
	state = idle_state
	
	initialization_done = true
	
