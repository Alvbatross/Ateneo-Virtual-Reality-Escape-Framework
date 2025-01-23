@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("OIS", "Node", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois.gd"), preload("res://icon.svg"))
	add_custom_type("OISActorComponent", "OIS", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-actor/ois_actor_component.gd"), preload("res://icon.svg"))
	add_custom_type("OISActorState", "OIS", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_actor_state.gd"), preload("res://icon.svg"))
	add_custom_type("OISActorStateMachine", "OIS", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_actor_state_machine.gd"), preload("res://icon.svg"))
	add_custom_type("OISSingleControllerASM", "OISActorStateMachine", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_single_controller_asm.gd"), preload("res://icon.svg"))
	add_custom_type("OISReceiverComponent", "OIS", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-receiver/ois_receiver_component.gd"), preload("res://icon.svg"))
	add_custom_type("ControllerIdleState", "OISActorState", preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/controller_idle_state.gd"), preload("res://icon.svg"))
	

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("OISReceiverComponent")
	remove_custom_type("OISActorStateMachine")
	remove_custom_type("OISSingleControllerASM")
	remove_custom_type("OISActorState")
	remove_custom_type("OISActorComponent")
	remove_custom_type("OIS")
	
