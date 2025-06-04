@tool
class_name OISActorComponent
extends OIS
## A Component used to create an OIS Actor. An OIS Actor allow for unique interactions with OIS Receivers.

@export_category("Actor Settings")
@export var receiver_group : String
@export var actor_rate : float = 1.0
@export var trigger_action : bool = false

@onready var actor : Variant = get_parent()

var actor_state_machine : OISActorStateMachine
var actor_collider : OISCollider
var ois_receiver : OISReceiverComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor_state_machine = find_actor_state_machine(self)
	actor_collider = find_ois_collider(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func get_actor() -> Variant:
	return actor


func set_receiver(receiver: OISReceiverComponent) -> void:
	ois_receiver = receiver


func get_receiver() -> OISReceiverComponent:
	return ois_receiver


func get_actor_rate() -> float:
	return actor_rate


func snap_actor_to_receiver() -> void:
	if is_instance_valid(ois_receiver):
		get_actor().global_position = ois_receiver.marker_3d.global_position + (get_actor().global_position - global_position)


func _on_ois_receiver_collision_entered(receiver) -> void:
	# Used receiver's parent to be able to make use of position-based interactions as the
	# actor component does not move on its own.
	actor_state_machine.handle_enter_collision(receiver)
	


func _on_ois_receiver_collision_exited(receiver) -> void:
	actor_state_machine.handle_exit_collision(receiver)
	#ois_receiver = null


func actor_component_enabled(b: bool) -> void:
	actor_collider.collider_enabled(b)


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
