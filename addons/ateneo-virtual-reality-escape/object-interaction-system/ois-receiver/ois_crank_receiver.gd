@tool
class_name OISCrankReceiver
extends OISReceiverComponent


var initial_direction
var past_progress = 0

var init_direction2
var action_comp_origin2
var init_handle_pos2
var curr_handle_pos2
var delta_angle_buffer2 = 0
var total_progress2 = 0
var past_progress2 = 0

@export var axis_of_rotation : Vector3 = Vector3(1, 0, 0)

func initialize_action_vars() -> void:
	initial_direction = interacting_object.position-position
	past_progress = total_progress
	
	delta_angle_buffer2 = 0
	action_comp_origin2 = position
	init_handle_pos2 = interacting_object.position
	init_direction2 = init_handle_pos2-action_comp_origin2
	init_direction2.x = 0
	past_progress2 = total_progress2
	set_process(true)


func action_ongoing(delta: float) -> void:
	var curr_direction = interacting_object.position - self.position 
	
	var current_progress = initial_direction.signed_angle_to(curr_direction, axis_of_rotation)
	
	total_progress = past_progress + (current_progress * rate);
	print(total_progress)
	super(delta)
