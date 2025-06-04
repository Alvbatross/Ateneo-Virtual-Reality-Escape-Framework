extends Node3D
var image_rotate
var progress_circle_component
var animation_player

@onready var progress_bar_viewport = $"Progress Bar Viewport"

## This must be changed per program if you want to reuse this progress bar.
@onready var camera : XRCamera3D = get_tree().get_root().get_node("Main").xr_camera_3d

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide at runtime.
	if is_instance_valid(progress_bar_viewport.get_node("Viewport").get_child(0)):
		progress_circle_component = progress_bar_viewport.get_node("Viewport").get_child(0)
		#progress_circle_component.control.visible = false
	
	change_progress_value(0)

func _physics_process(_delta):
	var cam_pos = camera.global_position
	look_at(cam_pos, Vector3.UP)
	rotate_object_local(Vector3.UP, PI)

func change_progress_value(value):
	progress_circle_component.progress_circle_component.value = value

func progress_complete_anim():
	progress_circle_component.animation_player.play("progress_complete")

func progress_complete_checkmark_only_anim():
	progress_circle_component.animation_player.play("progress_complete_checkmark_only")
	
func reset_progress():
	change_progress_value(0)
	progress_circle_component.animation_player.play("idle")
	
func progress_idle_state():
	progress_circle_component.animation_player.stop()
	progress_circle_component.animation_player.play("idle")

	
