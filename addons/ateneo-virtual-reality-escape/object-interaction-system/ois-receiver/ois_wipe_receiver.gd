@tool
class_name OISWipeReceiver
extends OISReceiverComponent

var interacting_inital_pos : Vector3
#var delta_dist_prev = 0
#var total_delta_dist = 0
var buffer = 0.02
#var old_buffer = 0.005
#var past_progress = 0


func initialize_action_vars():
	interacting_inital_pos = interacting_object.position
	#past_progress = total_progress
	
	#delta_dist_prev = 0
	#total_delta_dist = 0


func action_ongoing(delta: float) -> void:
	var interacting_current_pos = interacting_object.position
	
	var delta_dist = interacting_inital_pos.distance_to(interacting_current_pos)
	
	if (delta_dist > buffer):
		total_progress += rate * delta
	
	interacting_inital_pos = interacting_current_pos
	
	print("=======================")
	print("Total progress: "+str(total_progress))
	print("=======================\n")
	
	
	# THIS IS JOAN'S STUFF JUST IN CASE WE WANT IT BACK
	# =====================================================
	#var interacting_current_pos = interacting_object.position
	#
	#var delta_dist = interacting_inital_pos.distance_to(interacting_current_pos)
	#
	#var current_progress = total_delta_dist + delta_dist
	#
	#print ("Initial Position " + str(interacting_inital_pos))
	#
	#print("\n=========== "+ str(self.get_parent().name) + " interaction ===========")
	#print(str(interacting_object) + " position: "+str(interacting_object.position))
	#print("Delta distance: "+str(delta_dist))
		#
	#if(delta_dist < (delta_dist_prev - buffer)):
		#print("Delta distance is less than previous value minus buffer.")
		#total_delta_dist += delta_dist
		#interacting_inital_pos = interacting_object.position
	#
	#delta_dist_prev = delta_dist
	#
	#total_progress = past_progress + (current_progress * rate)
	#print("Total progress: "+str(total_progress))
	#print("=======================\n")
	
	super(delta)
