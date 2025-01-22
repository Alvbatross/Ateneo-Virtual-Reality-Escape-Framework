@tool
class_name OISActorState
extends OIS

var _ois_actor_state_machine: OISActorStateMachine

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter_state(_msg: Dictionary = {}) -> void:
	pass

func exit_state() -> void:
	pass
