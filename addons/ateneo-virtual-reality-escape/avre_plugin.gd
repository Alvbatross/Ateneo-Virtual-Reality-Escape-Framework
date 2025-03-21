@tool
extends EditorPlugin

var event_manager_ui := preload("res://addons/ateneo-virtual-reality-escape/event-management-system/event-manager-ui/event_manager_ui.tscn").instantiate()

var event := preload("res://addons/ateneo-virtual-reality-escape/event-management-system/event.gd")
var ois := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois.gd")
var ois_actor_component := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-actor/ois_actor_component.gd")
var ois_actor_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_actor_state.gd")
var active_colliding_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/active_colliding_state.gd")
var controller_active_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/controller_active_state.gd")
var controller_idle_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/controller_idle_state.gd")
var tool_active_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/tool_active_state.gd")
var tool_idle_state := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois-actor-states/tool_idle_state.gd")
var ois_actor_state_machine := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_actor_state_machine.gd")
var ois_single_controller_asm := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_single_controller_asm.gd")
var ois_one_hand_tool_asm := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-state-machine/ois_one_hand_tool_asm.gd")
var ois_receiver_component := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-receiver/ois_receiver_component.gd")
var ois_strike_receiver := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-receiver/ois_strike_receiver.gd")
var ois_twist_receiver := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-receiver/ois_twist_receiver.gd")
var ois_wipe_receiver := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-receiver/ois_wipe_receiver.gd")
var ois_collider := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-colliders/ois_collider.gd")
var ois_collider_area3d := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-colliders/ois_collider_area3d.gd")
var ois_collider_raycast3d := preload("res://addons/ateneo-virtual-reality-escape/object-interaction-system/ois-colliders/ois_collider_raycast3d.gd")


## Inventory System Related
var inventory_system_slot := preload("res://addons/ateneo-virtual-reality-escape/inventory-system/inventory_slot.gd")
var inventory_system := preload("res://addons/ateneo-virtual-reality-escape/inventory-system/inventory_system.gd")
var inventory_item := preload("res://addons/ateneo-virtual-reality-escape/inventory-system/inventory_item.gd")


## Teleportation System Related
var teleporter := preload("res://addons/ateneo-virtual-reality-escape/teleportation-system/teleporter.gd")
var teleporter_manager := preload("res://addons/ateneo-virtual-reality-escape/teleportation-system/teleporter_manager.gd")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	
	EditorInterface.get_editor_main_screen().add_child(event_manager_ui)
	_make_visible(false)
	
	add_autoload_singleton("EventManager", "res://addons/ateneo-virtual-reality-escape/event-management-system/event_manager.gd")
	
	add_custom_type("Event", "Node", event, preload("res://icon.svg"))
	add_custom_type("OIS", "Node", ois, preload("res://icon.svg"))
	add_custom_type("OISActorComponent", "OIS", ois_actor_component, preload("res://icon.svg"))
	add_custom_type("OISActorState", "OIS", ois_actor_state, preload("res://icon.svg"))
	add_custom_type("ActiveCollidingState", "OISActorState", active_colliding_state, preload("res://icon.svg"))
	add_custom_type("ControllerActiveState", "OISActorState", controller_active_state, preload("res://icon.svg"))
	add_custom_type("ControllerIdleState", "OISActorState", controller_idle_state, preload("res://icon.svg"))
	add_custom_type("ToolActiveState", "OISActorState", tool_active_state, preload("res://icon.svg"))
	add_custom_type("ToolIdleState", "OISActorState", tool_idle_state, preload("res://icon.svg"))
	add_custom_type("OISActorStateMachine", "OIS", ois_actor_state_machine, preload("res://icon.svg"))
	add_custom_type("OISSingleControllerASM", "OISActorStateMachine", ois_single_controller_asm, preload("res://icon.svg"))
	add_custom_type("OISOneHandToolASM", "OISActorStateMachine", ois_one_hand_tool_asm, preload("res://icon.svg"))
	add_custom_type("OISReceiverComponent", "OIS", ois_receiver_component, preload("res://icon.svg"))
	add_custom_type("OISStrikeReceiver", "OISReceiverComponent", ois_strike_receiver, preload("res://icon.svg"))
	add_custom_type("OISTwistReceiver", "OISReceiverComponent", ois_twist_receiver, preload("res://icon.svg"))
	add_custom_type("OISWipeReceiver", "OISReceiverComponent", ois_wipe_receiver, preload("res://icon.svg"))
	add_custom_type("OISCollider", "OIS", ois_collider, preload("res://icon.svg"))
	add_custom_type("OISColliderArea3D", "OISCollider", ois_collider_area3d, preload("res://icon.svg"))
	add_custom_type("OISColliderRaycast3D", "OISCollider", ois_collider_raycast3d, preload("res://icon.svg"))
	
	add_custom_type("InventorySlot", "Inventory", inventory_system_slot, preload("res://icon.svg"))
	add_custom_type("InventorySystem", "Inventory", inventory_system, preload("res://icon.svg"))
	add_custom_type("InventoryItem", "Inventory", inventory_item, preload("res://icon.svg"))
	
	add_custom_type("Teleporter", "Teleporter", teleporter, preload("res://icon.svg"))
	add_custom_type("TeleporterManager", "Teleporter", teleporter_manager, preload("res://icon.svg"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, event_manager_ui)
	
	event_manager_ui.queue_free()
	
	remove_autoload_singleton("EventManager")
	
	remove_custom_type("OISColliderRaycast3D")
	remove_custom_type("OISColliderArea3D")
	remove_custom_type("OISCollider")
	remove_custom_type("OISWipeReceiver")
	remove_custom_type("OISTwistReceiver")
	remove_custom_type("OISStrikeReceiver")
	remove_custom_type("OISReceiverComponent")
	remove_custom_type("OISOneHandToolASM")
	remove_custom_type("OISSingleControllerASM")
	remove_custom_type("OISActorStateMachine")
	remove_custom_type("ToolIdleState")
	remove_custom_type("ToolActiveState")
	remove_custom_type("ControllerIdleState")
	remove_custom_type("ControllerActiveState")
	remove_custom_type("ActiveCollidingState")
	remove_custom_type("OISActorState")
	remove_custom_type("OISActorComponent")
	remove_custom_type("OIS")
	remove_custom_type("Event")
	
	remove_custom_type("InventorySlot")
	remove_custom_type("InventorySystem")
	
	remove_custom_type("Teleporter")
	remove_custom_type("TeleporterManager")
	

func _has_main_screen() -> bool:
	return true

func _make_visible(visible):
	if event_manager_ui:
		event_manager_ui.visible = visible


func _get_plugin_name() -> String:
	return "Event Editor"
