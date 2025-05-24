@tool
class_name OISDirectionalSwipeReceiver
extends OISReceiverComponent

## Buffer set for minimal wipe distance in 1 frame. The lower the buffer the more sensitive each wipe movement is. 
@export var buffer : float = 0.02
@export var swipe_direction : Vector3
var interacting_initial_pos : Vector3


func initialize_action_vars():
	interacting_initial_pos = interacting_object.position

func action_ongoing(delta: float) -> void:
	var interacting_current_pos = interacting_object.position
	
	var delta_dir = interacting_current_pos - interacting_initial_pos
	var delta_dist = interacting_initial_pos.distance_to(interacting_current_pos)
	
	interacting_initial_pos = interacting_current_pos
	
	print(delta_dir.normalized())
	print(delta_dir.normalized().dot(swipe_direction))
	
	if delta_dir.normalized().dot(swipe_direction) > 0.75:
		if (delta_dist > buffer):
			total_progress += rate * delta
	
	print("=======================")
	print(self.name)
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	
	super(delta)
