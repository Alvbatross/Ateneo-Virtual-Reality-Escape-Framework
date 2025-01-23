class_name ControllerActiveState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	_ois_actor_state_machine.get_actor()._actor_collider.body_entered.connect(change_to_active_colliding)
	print(_ois_actor_state_machine.get_actor())
	print(_ois_actor_state_machine.get_actor()._actor_collider)

func change_to_active_colliding(_body): 
	_ois_actor_state_machine.transition_to("ActiveCollidingState", {})

func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func exit_state() -> void:
	pass
