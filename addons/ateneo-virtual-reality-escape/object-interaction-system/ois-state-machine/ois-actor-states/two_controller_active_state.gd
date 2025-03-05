class_name TwoControllerActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	_ois_actor_state_machine.get_actor_component().set_receiver(null)


func exit_state() -> void:
	pass


func physics_update(_delta : float) -> void:
	if _ois_actor_state_machine.left_hand_state_machine.state == "IdleState" and  _ois_actor_state_machine.right_hand_state_machine.state == "IdleState":
		_ois_actor_state_machine.transition_to("IdleState", {})
	if _ois_actor_state_machine.left_hand_state_machine.state == "ActiveCollidingState" or _ois_actor_state_machine.right_hand_state_machine.state == "ActiveCollidingState":
		_ois_actor_state_machine.transition_to("OneHandActiveCollidingState", {})
	
	
