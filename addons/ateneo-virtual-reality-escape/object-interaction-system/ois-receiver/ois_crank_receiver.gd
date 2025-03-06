@tool
class_name OISCrankReceiver
extends OISReceiverComponent


var initial_position

## Determines the direction of the twist action
@export_enum("Clockwise", "Counter-Clockwise") var twist_direction : int
## Check if the action should only go in one direction
@export var single_direction : bool = false

@export var axis_of_rotation : Vector3 = Vector3(1, 0, 0)

@onready var center : Vector3 = position

var total_angle : float = 0

func initialize_action_vars() -> void:
	initial_position = interacting_object.position - self.position


func action_ongoing(delta: float) -> void:
	var current_position = interacting_object.position - self.position
	
	var delta_angle = initial_position.signed_angle_to(current_position, axis_of_rotation)

	#if (delta_angle > PI || delta_angle < -PI):
		#delta_angle = sign(delta_angle)*(abs(delta_angle)-(2*PI))
	
	# Doesn't detect twisting in the opposite direction if single_direction is true
	if single_direction:
		if (twist_direction == CLOCKWISE and not delta_angle < 0) or (twist_direction == COUNTERCLOCKWISE and not delta_angle > 0):
			return
	
	initial_position = current_position
	
	var current_progress = rad_to_deg(delta_angle)
	
	if twist_direction == CLOCKWISE:
		current_progress *= -1
	
	total_angle += rad_to_deg(delta_angle)
	
	total_progress += current_progress * (rate / 360)
	
	print("=======================")
	print("Total angle: " + str(total_angle)) # test value, delete in future
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	super(delta)
