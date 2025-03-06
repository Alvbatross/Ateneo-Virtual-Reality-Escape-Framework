@tool
class_name OISTwistReceiver
extends OISReceiverComponent

## Determines the direction of the twist action
@export_enum("Clockwise", "Counter-Clockwise") var twist_direction : int
## Check if the action should only go in one direction
@export var single_direction : bool = false
var interacting_initial_angle : float
var past_progress : float = 0
var total_angle : float = 0


func initialize_action_vars():
	interacting_initial_angle = interacting_object.basis.get_euler().z
	past_progress = total_progress


func action_ongoing(delta: float) -> void:
	var interacting_current_angle = interacting_object.basis.get_euler().z
	
	var delta_angle = interacting_current_angle - interacting_initial_angle
	
	# get shortest angle between two angles
	if (delta_angle > PI || delta_angle < -PI):
		delta_angle = sign(delta_angle)*(abs(delta_angle)-(2*PI))
	
	# Doesn't detect twisting in the opposite direction if single_direction is true
	if single_direction:
		if (twist_direction == CLOCKWISE and not delta_angle > 0) or (twist_direction == COUNTERCLOCKWISE and not delta_angle < 0):
			return
	
	interacting_initial_angle = interacting_current_angle
	
	var current_progress = rad_to_deg(delta_angle) 
	
	if twist_direction == COUNTERCLOCKWISE:
		current_progress *= -1
	
	total_angle += rad_to_deg(delta_angle) # test value, delete in future
	
	total_progress += current_progress * (rate / 90)
	
	print("=======================")
	print("Total angle: " + str(total_angle)) # test value, delete in future
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	
	super(delta)

	
