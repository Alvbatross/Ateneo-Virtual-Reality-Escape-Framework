class_name ToolOneHandActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("I AM BEING HELD WITH 1 HAND")
	_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.connect(_on_actor_grabbed)
	_ois_actor_state_machine.get_actor_component().set_receiver(null)
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(true)

func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.disconnect(_on_actor_grabbed)
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(false)


func _on_enter_collision(receiver: Variant) -> void:
	print("I have entered a collision with " + receiver.get_parent().name)
	if not _ois_actor_state_machine.require_two_handed:
		if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
			if _ois_actor_state_machine.get_actor_component().get_actor() == receiver.get_parent().get_parent() and not receiver.get_parent().receive_from_self:
				print("Actor and Receiver is the same")
				return
			else:
				_ois_actor_state_machine.get_actor_component().set_receiver(receiver.get_parent())
				_ois_actor_state_machine.transition_to("OneHandActiveCollidingState", {})
		else:
			print("Incompatible Actor and Receiver")
	else:
		print("Hold the Object with Both Hands")


func _on_actor_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		if by.get_controller() in _ois_actor_state_machine.active_controllers:
			return
		else:
			_ois_actor_state_machine.active_controllers.append(by.get_controller())
			_ois_actor_state_machine.transition_to("TwoHandActiveState")


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.active_controllers.erase(by.get_controller())
	_ois_actor_state_machine.transition_to("IdleState")
