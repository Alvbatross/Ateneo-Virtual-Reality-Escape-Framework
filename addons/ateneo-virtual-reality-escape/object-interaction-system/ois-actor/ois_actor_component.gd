@tool
class_name OISActorComponent
extends OIS

var _actor_state_machine : OISActorStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actor_state_machine = find_actor_state_machine(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(_find_child(self, "OISActorStateMachine"))
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check Actor Component if it has an OISActorStateMachine
	if not find_actor_state_machine(self):
		warnings.append("OIS Actor does not have an OISActorStateMachine")

	# Return warnings
	return warnings


func find_actor_state_machine(node: Node) -> OISActorStateMachine:
	for child in node.get_children():
		if child is OISActorStateMachine:
			return child
	
	return null


static func _find_child(node : Node, type : String) -> Node:
	# Iterate through all children
	for child in node.get_children():
		# If the child is a match then return it
		if child.is_class(type):
			return child
	
		# Recurse into child
		var found := _find_child(child, type)
		if found:
			return found
	
	print("No state machines found")
	# No child found matching type
	return null
