class_name ToolIdleState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("I AM IDLE")
	_ois_actor_state_machine.controller = null
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(false)
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.connect(_on_actor_grabbed)
	_ois_actor_state_machine.get_actor_component().set_receiver(null)

func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.disconnect(_on_actor_grabbed)


func _on_actor_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		if _ois_actor_state_machine is OISTwoHandToolASM:
			_ois_actor_state_machine.active_controllers.append(by.get_controller())
			_ois_actor_state_machine.transition_to("OneHandActiveState")
		else:
			_ois_actor_state_machine.controller = by.get_controller()
			_ois_actor_state_machine.transition_to("ActiveState")


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
