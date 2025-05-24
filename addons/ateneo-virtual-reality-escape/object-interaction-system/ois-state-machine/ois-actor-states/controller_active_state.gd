class_name ControllerActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(true)
	_ois_actor_state_machine.get_actor_component().get_actor().get_node("FunctionPickup").has_picked_up.connect(_on_controller_pick_up)
	_ois_actor_state_machine.get_actor_component().set_receiver(null)

func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().get_node("FunctionPickup").has_picked_up.disconnect(_on_controller_pick_up)


func _on_enter_collision(receiver: Variant) -> void:
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
		if _ois_actor_state_machine.get_actor_component().get_actor() == receiver.get_parent().get_parent() and not receiver.get_parent().receive_from_self:
			print("Actor and Receiver is the same")
			return
		else:
			_ois_actor_state_machine.get_actor_component().set_receiver(receiver.get_parent())
			_ois_actor_state_machine.transition_to("ActiveCollidingState", {})
	else:
		print("Incompatible Actor and Receiver")


func _on_controller_pick_up(_actor: XRToolsPickable) -> void:
	print("Controller is IDLE")
	_ois_actor_state_machine.transition_to("IdleState")

#
#func update(_delta: float) -> void:
	#pass
#
#
#func physics_update(_delta: float) -> void:
	#pass
#
#
#
