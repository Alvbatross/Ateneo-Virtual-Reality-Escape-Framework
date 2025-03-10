extends Node3D


@onready var white_flash: MeshInstance3D = $WhiteFlash
@onready var spot_light: SpotLight3D = $SpotLight
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"

var crank_mov_bool : bool
var testint: float
var keep_fully_charged_state : bool


func _ready() -> void:
	white_flash.get_surface_override_material(0).albedo_color.a = 0
	testint = 0
	
func _process(_delta: float) -> void:
	
	if testint > 0:
		testint -= 0.002
	
	var new_test : float
	if testint > 1:
		new_test = 1
	elif testint <= 1:
		new_test = testint
		
	white_flash.get_surface_override_material(0).albedo_color.a = 1 * new_test
	spot_light.light_energy = 3 * new_test
	audio_stream_player_3d.volume_db = 0 - (20 * new_test)
	audio_stream_player_3d.pitch_scale = 1 * new_test + 0.01
		
	
func _on_ois_crank_receiver_action_in_progress(_requirement: Variant, _total_progress: Variant) -> void:
	if testint < 1.5:
		testint += 0.05
