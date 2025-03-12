class_name OneHandActiveCollidingState
extends OISActorState


var trigger_press = func(x): if (x == "trigger_click"): _on_trigger_press()
var trigger_release = func(x): if (x == "trigger_click"): _on_trigger_release()


func enter_state(_msg: Dictionary = {}) -> void:
	print("I AM ACTIVE WITH 1 HAND")
	var actor = _ois_actor_state_machine.get_actor_component().get_actor()
	if actor is XRToolsPickable:
		_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
		_ois_actor_state_machine.get_actor_component().get_actor().grabbed.connect(_on_actor_grabbed)
	for control in _ois_actor_state_machine.active_controllers:
		control.button_pressed.connect(trigger_press)
		control.button_released.connect(trigger_release)
	_ois_actor_state_machine.get_actor_component().get_receiver().start_action_check(_ois_actor_state_machine.get_actor_component(), 0.5)


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	trigger_on = false
	_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
	_ois_actor_state_machine.get_actor_component().set_receiver(null)
	_ois_actor_state_machine.active_controllers.erase(by.get_controller())
	_ois_actor_state_machine.transition_to("IdleState")


func _on_exit_collision(receiver: Variant) -> void:
	if is_instance_valid(receiver):
		if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
			_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
			var actor = _ois_actor_state_machine.get_actor_component().get_actor()
			if actor is XRToolsPickable:
				_ois_actor_state_machine.transition_to("OneHandActiveState", {})



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
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.disconnect(_on_actor_grabbed)
	for control in _ois_actor_state_machine.active_controllers:
		control.button_pressed.disconnect(trigger_press)
		control.button_released.disconnect(trigger_release)
	


func _on_actor_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		if by.get_controller() in _ois_actor_state_machine.active_controllers:
			return
		else:
			_ois_actor_state_machine.active_controllers.append(by.get_controller())
			_ois_actor_state_machine.transition_to("TwoHandActiveCollidingState")
