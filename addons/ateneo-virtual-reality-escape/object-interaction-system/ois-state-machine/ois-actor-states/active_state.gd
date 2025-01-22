class_name ActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	_ois_actor_state_machine.get_actor()._actor_collider.body_entered.connect(_ois_actor_state_machine.transition_to, "ActiveCollidingState")


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func exit_state() -> void:
	pass
