@tool
class_name OISOneHandToolASM
extends OISActorStateMachine

var idle_state : ToolIdleState
var active_state : ToolActiveState
var active_colliding_state : ActiveCollidingState


func initialize() -> void:
	idle_state = ToolIdleState.new()
	idle_state.name = "IdleState"
	add_child(idle_state)
	
	active_state = ToolActiveState.new()
	active_state.name = "ActiveState"
	add_child(active_state)
	
	active_colliding_state = ActiveCollidingState.new()
	active_colliding_state.name = "ActiveCollidingState"
	add_child(active_colliding_state)
	
	state = idle_state
	
	initialization_done = true
