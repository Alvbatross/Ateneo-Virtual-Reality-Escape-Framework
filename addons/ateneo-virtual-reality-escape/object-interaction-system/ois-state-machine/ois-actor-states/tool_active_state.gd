class_name ToolActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Active State")
	_ois_actor_state_machine.get_actor_component().get_actor().dropped.connect(_on_actor_dropped)


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().dropped.disconnect(_on_actor_dropped)


func _on_enter_collision(receiver: Variant) -> void:
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
		_ois_actor_state_machine.get_actor_component().set_receiver(receiver.get_parent())
		_ois_actor_state_machine.transition_to("ActiveCollidingState", {})
	else:
		print("Incompatible Actor and Receiver")


func _on_actor_dropped(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.transition_to("IdleState")
