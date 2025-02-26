class_name OISCollider
extends OIS

signal body_entered(body)
signal body_exited(body)

@export_flags_3d_physics var ois_collision_layer : int = COLLISION_LAYER

@onready var actor : OISActorComponent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if actor is OISActorComponent:
		body_entered.connect(actor._on_ois_receiver_collision_entered)
		body_exited.connect(actor._on_ois_receiver_collision_exited)


func collider_enabled(b: bool) -> void:
	pass
