class_name ToolActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print(_ois_actor_state_machine.get_actor_component().get_actor().name + "IS ACTIVE")
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(true)
	_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
	_ois_actor_state_machine.get_actor_component().set_receiver(null)

func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)


func _on_enter_collision(receiver: Variant) -> void:
	print("Entered collision")
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
		if _ois_actor_state_machine.get_actor_component().get_actor() == receiver.get_parent().get_parent() and not receiver.get_parent().receive_from_self:
			print("Actor and Receiver is the same")
			return
		else:
			_ois_actor_state_machine.get_actor_component().set_receiver(receiver.get_parent())
			_ois_actor_state_machine.transition_to("ActiveCollidingState", {})
	else:
		print("=============================================")
		print("Incompatible Actor and Receiver")
		print(_ois_actor_state_machine.get_actor_component().get_actor())
		print(receiver.get_parent())
		print("=============================================")


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.controller = null
	_ois_actor_state_machine.transition_to("IdleState")

func physics_update(_delta: float) -> void:
	pass
