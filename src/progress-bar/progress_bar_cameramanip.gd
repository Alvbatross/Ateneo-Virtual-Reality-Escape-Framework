extends Node3D

var camera

@export var object_height : float 
var image_rotate

@onready var progress_circle_component = $"Viewport2Din3D/Viewport/Progress Circle2/ProgressCircleComponent"
@onready var animation_player = $"Viewport2Din3D/Viewport/Progress Circle2/AnimationPlayer"



func initialize_progress_bar_position(mode: String) -> void:
	if mode == "NonVR":
		camera = null
		print(camera.name)
	elif mode == "VR":
		camera = get_tree().get_root().get_node("TestProject/XRPlayer/XROrigin3D/XRCamera3D")
		if self.get_node("Viewport2Din3D/Viewport").get_child(1) != null:
			self.get_node("Viewport2Din3D/Viewport").get_child(1).visible = false
		print("PROGRESS BAR:"+ camera.name)
		
		image_rotate = self.get_parent().global_rotation.y

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_progress_bar_position("VR")
	progress_circle_component.value = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	var cam_pos = camera.global_position
	look_at(cam_pos, Vector3.UP)
	rotate_object_local(Vector3.UP, PI)


func change_progress_value(value):
	progress_circle_component.value = value


func progress_complete_anim():
	animation_player.play("progress_complete")

func progress_complete_checkmark_only_anim():
	animation_player.play("progress_complete_checkmark_only")

	
