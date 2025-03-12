@tool
class_name OISAttachReceiver
extends OISReceiverComponent



@export var buffer : float = 0.1
@export var is_primary_attacher : bool = false
@export var replacement_object_path : String
var interacting_initial_pos : Vector3

var is_attached : bool = false
var attached_to : Variant = null



func initialize_action_vars():
	interacting_initial_pos = interacting_object.position


func action_ongoing(delta: float) -> void:
	if not is_attached:
		if self.position.distance_to(interacting_actor.position) < buffer:
			is_attached = true
			attached_to = interacting_object 
			if is_primary_attacher:
				var replacement_object = load(replacement_object_path)
				var new_object = replacement_object.instantiate()
				get_parent().get_parent().add_child(new_object)
				interacting_actor.actor_state_machine.controller.get_node("FunctionPickup")._pick_up_object(new_object)
				get_parent().queue_free()
				attached_to.queue_free()
			print("YAY Attached the Objects")
	#var interacting_current_pos = interacting_object.position
	#
	#var delta_dist = interacting_initial_pos.distance_to(interacting_current_pos)
	#
	#interacting_initial_pos = interacting_current_pos
	#
	#if (delta_dist > buffer):
		#total_progress += rate * delta
	#
	#print("=======================")
	#print("Total progress: "+str(total_progress))
	#print("=======================\n")
	
		super(delta)
