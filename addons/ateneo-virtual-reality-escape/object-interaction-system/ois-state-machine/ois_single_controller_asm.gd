@tool
class_name OISSingleControllerASM
extends OISActorStateMachine

var idle_state : IdleState
var active_state : ActiveState
var active_colliding_state : ActiveCollidingState


func initialize_states() -> void:
	if not has_node("IdleState"):
		idle_state = IdleState.new()
		idle_state.name = "IdleState"
		add_child(idle_state)
		idle_state.owner = get_tree().edited_scene_root
	
	if not has_node("ActiveState"):
		active_state = ActiveState.new()
		active_state.name = "ActiveState"
		add_child(active_state)
		active_state.owner = get_tree().edited_scene_root
	
	if not has_node("ActiveCollidingState"):
		active_colliding_state = ActiveCollidingState.new()
		active_colliding_state.name = "ActiveCollidingState"
		add_child(active_colliding_state)
		active_colliding_state.owner = get_tree().edited_scene_root
	
	state = idle_state
