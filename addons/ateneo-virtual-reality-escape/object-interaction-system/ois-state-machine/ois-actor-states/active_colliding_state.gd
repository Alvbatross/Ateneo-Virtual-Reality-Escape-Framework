class_name ActiveCollidingState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Active Colliding State")
	_ois_actor_state_machine.get_actor().get_receiver().start_action_check(_ois_actor_state_machine.get_actor())


func _on_exit_collision(receiver: Variant) -> void:
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor().receiver_group):
		_ois_actor_state_machine.get_actor().set_receiver(null)
		_ois_actor_state_machine.transition_to("ActiveState", {})


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	_ois_actor_state_machine.get_actor().get_receiver().action_ongoing(delta)


func exit_state() -> void:
	pass
