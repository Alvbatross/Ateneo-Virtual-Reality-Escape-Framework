class_name ActiveCollidingState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Active Colliding State")
	var actor = _ois_actor_state_machine.get_actor_component().get_actor()
	if actor is XRToolsPickable:
		_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
	_ois_actor_state_machine.get_actor_component().get_receiver().start_action_check(_ois_actor_state_machine.get_actor_component())


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
	_ois_actor_state_machine.get_actor_component().set_receiver(null)
	_ois_actor_state_machine.transition_to("IdleState")


func _on_exit_collision(receiver: Variant) -> void:
	if is_instance_valid(receiver):
		if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
			_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
			_ois_actor_state_machine.get_actor_component().set_receiver(null)
			_ois_actor_state_machine.transition_to("ActiveState", {})


func physics_update(delta: float) -> void:
	var receiver = _ois_actor_state_machine.get_actor_component().get_receiver()
	if is_instance_valid(receiver):
		if receiver.trigger_action:
			pass
		else:
			receiver.action_ongoing(delta)


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)
