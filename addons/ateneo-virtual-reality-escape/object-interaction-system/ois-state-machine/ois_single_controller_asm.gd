@tool
class_name OISSingleControllerASM
extends OISActorStateMachine

var idle_state : ControllerIdleState
var active_state : ControllerActiveState
var active_colliding_state : ActiveCollidingState


func initialize() -> void:
	idle_state = ControllerIdleState.new()
	idle_state.name = "IdleState"
	add_child(idle_state)
	
	active_state = ControllerActiveState.new()
	active_state.name = "ActiveState"
	add_child(active_state)
	
	active_colliding_state = ActiveCollidingState.new()
	active_colliding_state.name = "ActiveCollidingState"
	add_child(active_colliding_state)
	
	controller = get_actor_component().get_actor()
	
	state = active_state
	
	initialization_done = true
