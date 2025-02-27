class_name ToolTwoHandActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("I AM BEING HELD BY 2 HANDS")
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(true)
	_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)


func _on_enter_collision(receiver: Variant) -> void:
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
		pass
		#_ois_actor_state_machine.get_actor_component().set_receiver(receiver.get_parent())
		#_ois_actor_state_machine.transition_to("ActiveCollidingState", {})
	else:
		print("Incompatible Actor and Receiver")


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.active_controllers.erase(by.get_controller())
	_ois_actor_state_machine.transition_to("OneHandActiveState")
