@tool
class_name OISActorComponent
extends OIS
## A Component used to create an OIS Actor. An OIS Actor allow for unique interactions with OIS Receivers.

var _actor_state_machine : OISActorStateMachine
var _actor_collider 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actor_state_machine = find_actor_state_machine(self)
	_actor_collider = find_ois_collider(self)
	
	print(_actor_state_machine)
	print(_actor_collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_ois_receiver_collision_entered(receiver) -> void:
	pass


func _on_ois_receiver_collision_exited(receiver) -> void:
	pass


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check Actor Component if it has an OISActorStateMachine
	if not find_actor_state_machine(self):
		warnings.append("OIS Actor does not have an OISActorStateMachine")
	
	if not find_ois_collider(self):
		warnings.append("OIS Actor does not have an OISCollider")

	# Return warnings
	return warnings


func find_actor_state_machine(node: Node) -> OISActorStateMachine:
	for child in node.get_children():
		if child is OISActorStateMachine:
			return child
	
	return null


func find_ois_collider(node: Node) -> OISCollider:
	for child in node.get_children():
		if child is OISCollider:
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
