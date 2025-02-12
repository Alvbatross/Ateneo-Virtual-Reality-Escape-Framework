@tool
class_name OISActorState
extends OIS

var _ois_actor_state_machine: OISActorStateMachine

var ois_receiver : OISReceiverComponent

var trigger_on : bool = false

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass


func _on_enter_collision(receiver: Variant) -> void:
	pass

func _on_exit_collision(receiver: Variant) -> void:
	pass


func _on_trigger_press() -> void:
	pass

func _on_trigger_release() -> void:
	pass


func enter_state(_msg: Dictionary = {}) -> void:
	pass

func exit_state() -> void:
	pass
