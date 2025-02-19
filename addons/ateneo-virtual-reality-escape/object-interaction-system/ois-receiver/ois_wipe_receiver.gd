@tool
class_name OISWipeReceiver
extends OISReceiverComponent

## Buffer set for minimal wipe distance in 1 frame. The lower the buffer the more sensitive each wipe movement is. 
@export var buffer : float = 0.02
var interacting_initial_pos : Vector3


func initialize_action_vars():
	interacting_initial_pos = interacting_object.position

func action_ongoing(delta: float) -> void:
	var interacting_current_pos = interacting_object.position
	
	var delta_dist = interacting_initial_pos.distance_to(interacting_current_pos)
	
	interacting_initial_pos = interacting_current_pos
	
	if (delta_dist > buffer):
		total_progress += rate * delta
	
	print("=======================")
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	
	super(delta)
