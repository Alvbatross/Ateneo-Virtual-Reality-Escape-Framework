class_name ControllerIdleState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Idle State")
	_ois_actor_state_machine.get_actor_component().actor_component_enabled(false)
	_ois_actor_state_machine.get_actor_component().get_actor().get_node("FunctionPickup").has_dropped.connect(_on_controller_dropped)


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().get_node("FunctionPickup").has_dropped.disconnect(_on_controller_dropped)


func _on_controller_dropped() -> void:
	_ois_actor_state_machine.transition_to("ActiveState")
