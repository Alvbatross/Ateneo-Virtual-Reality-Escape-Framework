extends Marker3D

@export var axis : Vector3 = Vector3(0, 0, 1)
var init_transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_transform = self.transform.basis
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ois_crank_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	self.transform.basis = init_transform
	self.rotate_object_local(axis, total_progress)
