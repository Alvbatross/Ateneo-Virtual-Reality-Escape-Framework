class_name ControllerActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Active State")


func _on_enter_collision(receiver: Variant) -> void:
	if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor().receiver_group):
		_ois_actor_state_machine.get_actor().set_receiver(receiver.get_parent())
		_ois_actor_state_machine.transition_to("ActiveCollidingState", {})

#
#func update(_delta: float) -> void:
	#pass
#
#
#func physics_update(_delta: float) -> void:
	#pass
#
#
#func exit_state() -> void:
	#pass
