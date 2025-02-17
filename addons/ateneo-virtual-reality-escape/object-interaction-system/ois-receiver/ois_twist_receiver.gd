@tool
class_name OISTwistReceiver
extends OISReceiverComponent

var interacting_initial_angle
var delta_angle_buffer
var past_progress = 0
var total_angle : float = 0


func initialize_action_vars():
	interacting_initial_angle = interacting_object.basis.get_euler().z
	past_progress = total_progress
	delta_angle_buffer = 0


func action_ongoing(delta: float) -> void:
	var interacting_current_angle = interacting_object.basis.get_euler().z

	var delta_angle = interacting_current_angle-interacting_initial_angle
	
	interacting_initial_angle = interacting_current_angle
	
	# get shortest angle between two angles
	if (delta_angle > PI || delta_angle < -PI):
		delta_angle = sign(delta_angle)*(abs(delta_angle)-(2*PI))
		
	var current_progress = delta_angle_buffer + delta_angle * (180/PI)

	total_progress += current_progress * (rate / 90)
	print("=======================")
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	
	super(delta)

	
