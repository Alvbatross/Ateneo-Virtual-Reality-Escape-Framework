class_name TwoHandActiveCollidingState
extends OISActorState


var trigger_press = func(x): if (x == "trigger_click"): _on_trigger_press()
var trigger_release = func(x): if (x == "trigger_click"): _on_trigger_release()

var active_triggers : int = 0
var both_triggers_on : bool = false

func enter_state(_msg: Dictionary = {}) -> void:
	active_triggers = 0
	print("I AM ACTIVE WITH BOTH HANDS")
	var actor = _ois_actor_state_machine.get_actor_component().get_actor()
	if actor is XRToolsPickable:
		_ois_actor_state_machine.get_actor_component().get_actor().released.connect(_on_actor_released)
	for control in _ois_actor_state_machine.active_controllers:
		control.button_pressed.connect(trigger_press)
		control.button_released.connect(trigger_release)
	_ois_actor_state_machine.get_actor_component().get_receiver().start_action_check(_ois_actor_state_machine.get_actor_component(), 1.0)


func _on_actor_released(pickable: Variant, by: Variant) -> void:
	print("I Exit Through Actor Released Collision")
	trigger_on = false
	_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
	_ois_actor_state_machine.get_actor_component().set_receiver(null)
	_ois_actor_state_machine.active_controllers.erase(by.get_controller())
	_ois_actor_state_machine.transition_to("OneHandActiveState")


func _on_exit_collision(receiver: Variant) -> void:
	if is_instance_valid(receiver):
		if receiver.get_parent().is_in_group(_ois_actor_state_machine.get_actor_component().receiver_group):
			_ois_actor_state_machine.get_actor_component().get_receiver().end_action()
			var actor = _ois_actor_state_machine.get_actor_component().get_actor()
			if actor is XRToolsPickable:
				_ois_actor_state_machine.transition_to("TwoHandActiveState", {})


func physics_update(delta: float) -> void:
	print(both_triggers_on)
	var receiver = _ois_actor_state_machine.get_actor_component().get_receiver()
	print(receiver)
	if is_instance_valid(receiver):
		if _ois_actor_state_machine.get_actor_component().trigger_action:
			if both_triggers_on:
				if receiver.snap_actor:
					_ois_actor_state_machine.get_actor_component().snap_actor_to_receiver()
				receiver.action_ongoing(delta)
		else:
			if receiver.snap_actor:
					_ois_actor_state_machine.get_actor_component().snap_actor_to_receiver()
			receiver.action_ongoing(delta)
	



func _on_trigger_press() -> void:
	active_triggers += 1
	print(active_triggers)
	if active_triggers == 2:
		both_triggers_on = true


func _on_trigger_release() -> void:
	active_triggers -= 1
	if active_triggers < 2:
		both_triggers_on = false


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().released.disconnect(_on_actor_released)
	for control in _ois_actor_state_machine.active_controllers:
		control.button_pressed.disconnect(trigger_press)
		control.button_released.disconnect(trigger_release)
	
