@tool
class_name OISDetachReceiver
extends OISReceiverComponent

@export var primary_replacement_object_path : String
@export var secondary_replacement_object_path : String

var primary_hand
var secondary_hand


func initialize_action_vars():
	primary_hand = interacting_actor.actor_state_machine.active_controllers[0]
	secondary_hand = interacting_actor.actor_state_machine.active_controllers[1]

func _physics_process(delta: float) -> void:
	pass

func action_ongoing(delta: float) -> void:
	print("I Am happening")
	print(primary_hand.global_position.distance_to(secondary_hand.global_position))
	if primary_hand.global_position.distance_to(secondary_hand.global_position) > requirement:
		var primary_replacement_object = load(primary_replacement_object_path)
		var secondary_replacement_object = load(secondary_replacement_object_path)
		var new_primary_obj = primary_replacement_object.instantiate()
		var new_secondary_obj = secondary_replacement_object.instantiate()
		
		for child in new_primary_obj.get_children():
			if child is OISAttachReceiver:
				child.is_primary_attacher = true
		
		get_parent().get_parent().add_child(new_primary_obj)
		get_parent().get_parent().add_child(new_secondary_obj)
		
		get_parent().queue_free()
		
		primary_hand.get_node("FunctionPickup")._pick_up_object(new_primary_obj)
		secondary_hand.get_node("FunctionPickup")._pick_up_object(new_secondary_obj)
		
		
		
		#if self.position.distance_to(interacting_actor.position) < buffer:
			#is_attached = true
			#attached_to = interacting_object 
			#if is_primary_attacher:
				#var new_object = replacement_object.instantiate()
				#get_parent().get_parent().add_child(new_object)
				#interacting_actor.actor_state_machine.controller.get_node("FunctionPickup")._pick_up_object(new_object)
				#get_parent().queue_free()
				#attached_to.queue_free()
			#print("YAY Attached the Objects")
		super(delta)
