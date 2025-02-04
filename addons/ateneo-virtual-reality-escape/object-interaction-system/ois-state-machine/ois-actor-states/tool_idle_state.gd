class_name ToolIdleState
extends OISActorState


func enter_state(_msg: Dictionary = {}) -> void:
	print("Entered Idle State")
	#_ois_actor_state_machine.get_actor_component().actor_component_enabled(false)
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.connect(_on_actor_grabbed)


func exit_state() -> void:
	_ois_actor_state_machine.get_actor_component().get_actor().grabbed.disconnect(_on_actor_grabbed)


func _on_actor_grabbed(pickable: Variant, by: Variant) -> void:
	_ois_actor_state_machine.transition_to("ActiveState")



func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
