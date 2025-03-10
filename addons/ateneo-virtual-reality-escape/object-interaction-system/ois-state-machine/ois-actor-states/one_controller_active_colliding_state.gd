class_name OneControllerActiveCollidingState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	pass


func exit_state() -> void:
	pass


func physics_update(_delta : float) -> void:
	if _ois_actor_state_machine.left_hand_state_machine.state == "IdleState" and  _ois_actor_state_machine.right_hand_state_machine.state == "IdleState":
		_ois_actor_state_machine.transition_to("IdleState", {})
	if _ois_actor_state_machine.left_hand_state_machine.state == "ActiveCollidingState" and _ois_actor_state_machine.right_hand_state_machine.state == "ActiveCollidingState":
		_ois_actor_state_machine.transition_to("TwoControllerActiveCollidingState", {})
	
	
