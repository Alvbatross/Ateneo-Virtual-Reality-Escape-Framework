@tool
class_name OISActorComponent
extends OIS

var _actor_state_machine : OISActorStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actor_state_machine = _find_child(self, "OISActorStateMachine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check Actor Component if it has an OISActorStateMachine
	if not _find_child(self, "OISActorStateMachine"):
		warnings.append("OIS Actor does not have an OISActorStateMachine")

	# Return warnings
	return warnings


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

	# No child found matching type
	return null
