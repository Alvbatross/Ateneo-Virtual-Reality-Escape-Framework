class_name ActiveCollidingState
extends OISActorState


var trigger_press = func(x): if (x == "trigger_click"): _on_trigger_press()
var trigger_release = func(x): if (x == "trigger_click"): _on_trigger_release()


func enter_state(_msg: Dictionary = {}) -> void:
	print("I AM ACTIVELY COLLIDING")
	var actor = _ois_actor_state_machine.get_actor_component().get_actor()
	if actor is XRToolsPickable:
		_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
	_ois_actor_state_machine.controller.button_pressed.connect(trigger_press)
	_ois_actor_state_machine.controller.button_released.connect(trigger_release)
	_ois_actor_state_machine.get_actor_component().get_receiver().start_action_check(_ois_actor_state_machine.get_actor_component(), 1.0)


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	trigger_on = false
	_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
	_ois_actor_state_machine.get_actor_component().set_receiver(null)
	_ois_actor_state_machine.transition_to("IdleState")


func _on_exit_collision(receiver: Variant) -> void:
	if is_instance_valid(receiver):
		if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
			_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
			_ois_actor_state_machine.get_actor_component().set_receiver(null)
			_ois_actor_state_machine.transition_to("ActiveState", {})


func physics_update(delta: float) -> void:
	var receiver = _ois_actor_state_machine.get_actor_component().get_receiver()
	if is_instance_valid(receiver):
		if _ois_actor_state_machine.get_actor_component().trigger_action:
			if trigger_on:
				if receiver.snap_actor:
					_ois_actor_state_machine.get_actor_component().snap_actor_to_receiver()
				receiver.action_ongoing(delta)
		else:
			if receiver.snap_actor:
					_ois_actor_state_machine.get_actor_component().snap_actor_to_receiver()
			receiver.action_ongoing(delta)


func _on_trigger_press() -> void:
	trigger_on = true


func _on_trigger_release() -> void:
	trigger_on = false


func exit_state() -> void:
	var actor = _ois_actor_state_machine.get_actor_component().get_actor()
	if actor is XRToolsPickable:
		_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)
	_ois_actor_state_machine.controller.button_pressed.disconnect(trigger_press)
	_ois_actor_state_machine.controller.button_released.disconnect(trigger_release)
	
