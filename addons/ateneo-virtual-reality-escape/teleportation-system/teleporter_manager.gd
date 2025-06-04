@tool
class_name TeleporterManager
extends Node3D

signal location_changed(location_name)

@export var current_location : Teleporter:
	set(current_loc):
		if current_location != current_loc:
			current_location = current_loc

@export var enabled : bool = false

@export_category("XR Settings")

@export var teleporter_trigger_button : String = "trigger_click"

@export var xr_origin: XROrigin3D:
	set(xr_origin_node):
		if xr_origin != xr_origin_node:
			xr_origin = xr_origin_node
		#_initialize_xr_origin_nodes(xr_origin_node)
		
@export var xr_camera: XRCamera3D

@export var xr_left_function_pointer: XRToolsFunctionPointer
@export var xr_right_function_pointer: XRToolsFunctionPointer

@onready var _controller_left_node := XRHelpers.get_left_controller(xr_left_function_pointer)
@onready var _controller_right_node := XRHelpers.get_right_controller(xr_right_function_pointer)

@export_category("Transition Options")
@export var audio_node : AudioStreamPlayer3D
@export var fade_mesh : Node3D

@export_category("(Optional) Spectator Camera")
@export var spectator_camera : Camera3D

@export_category("Editor Settings")
@export var update_connections : bool

@export_category("Debug")
@export var pointing_at : Teleporter
@export var active_controller : XRController3D

var teleport_called : bool
var initial_teleport : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_initialize_xr_components()
	
	if not Engine.is_editor_hint():
		teleport_called = true
		if teleport_called and is_instance_valid(current_location):
			initial_teleport = true
			_teleport_player(current_location)
			teleport_called = false
			initial_teleport = false
		_connect_controller_buttons()
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if update_connections:
			for teleporters in get_children():
				teleporters._update_connections()
			print("[AVRE - TeleportManager] Updated connections on all teleporters.")
			update_connections = false
	_set_teleporter_states()
	
	if teleport_called and is_instance_valid(pointing_at):
		_teleport_player(pointing_at)
		teleport_called = false
	
	if not Engine.is_editor_hint():
		_runtime_pointer()
	
func _set_teleporter_states() -> void:
	if enabled:
		if is_instance_valid(current_location):
			for teleporters_a in self.get_children():
				if teleporters_a == current_location:
					teleporters_a.current_teleporter = true
				else:
					teleporters_a.current_teleporter = false
				if teleporters_a not in current_location.connected_teleporters or not teleporters_a.teleporter_active:
					teleporters_a.teleporter_enabled = false
				elif teleporters_a == current_location or teleporters_a in current_location.connected_teleporters and teleporters_a.teleporter_active:
					teleporters_a.teleporter_enabled = true
	else:
		for teleporters in self.get_children():
			teleporters.teleporter_enabled = false

func _teleport_player(location : Teleporter) -> void:
	# Still unsure about this, will have to confirm later, but it works as expected.
	print("[AVRE - TeleportManager] Teleported to "+location.teleporter_name+".")
	if !initial_teleport:
		_fade_out()
	if is_instance_valid(audio_node):
		audio_node.playing = true
	if is_instance_valid(fade_mesh):
		await get_tree().create_timer(1).timeout
	#xr_origin.position = location.teleporter_position
	
	# Separate y position from position of x and z axes to preserve height.
	xr_origin.position.x = location.teleporter_position.x
	xr_origin.position.y = xr_origin.position.y + location.teleporter_position.y
	xr_origin.position.z = location.teleporter_position.z
	
	xr_camera.rotation.y = deg_to_rad(location.teleporter_rotation.y)
	xr_camera.rotation.z = deg_to_rad(location.teleporter_rotation.z)
	xr_camera.rotation.x = deg_to_rad(location.teleporter_rotation.x)
	if is_instance_valid(audio_node):
		audio_node.position = xr_origin.position
	
	if is_instance_valid(spectator_camera):
		_teleport_spectator_camera(location)
	
	current_location = location
	_fade_in()
	emit_signal("location_changed", location.teleporter_name)

func _teleport_spectator_camera(teleporter : Teleporter) -> void:
	spectator_camera.rotation.y = teleporter.spectator_camera_rotation.y
	spectator_camera.rotation.x = teleporter.spectator_camera_rotation.x
	spectator_camera.rotation.z = teleporter.spectator_camera_rotation.z
	spectator_camera.position = teleporter.spectator_camera_position
	
	
func _runtime_pointer() -> void:	
	if is_instance_valid(xr_right_function_pointer) and is_instance_valid(xr_left_function_pointer):
		if is_instance_valid(xr_right_function_pointer.get_node("RayCast").get_collider()):
			if pointing_at == null:
				if xr_right_function_pointer.get_node("RayCast").get_collider().get_parent() is Teleporter:
					pointing_at = xr_right_function_pointer.get_node("RayCast").get_collider().get_parent()
					pointing_at.aimed_at = true
		elif is_instance_valid(xr_left_function_pointer.get_node("RayCast").get_collider()):
			if pointing_at == null:
				if xr_left_function_pointer.get_node("RayCast").get_collider().get_parent() is Teleporter:
					pointing_at = xr_left_function_pointer.get_node("RayCast").get_collider().get_parent()
					pointing_at.aimed_at = true
		else:
			if pointing_at is Teleporter:
				pointing_at.aimed_at = false
			pointing_at = null


func _initialize_xr_components() -> void:
	for nodes in get_parent().get_children():
		if nodes.name == "XRPlayer":
			if nodes.get_child(0) is XROrigin3D:
				print("[AVRE - TeleportManager] XROrigin3D found.")
				xr_origin = nodes.get_child(0)
	
	if xr_origin != null:
		_initialize_xr_origin_nodes(xr_origin)
	else:
		print("[AVRE - TeleportManager] No XROrigin3D found.")
		

func _initialize_xr_origin_nodes(xr_origin_nodes : XROrigin3D) -> void:
		print("[AVRE - TeleportManager] Setting up XROrigin child nodes.")
		for nodes in xr_origin_nodes.get_children():
			if nodes is XRCamera3D:
				xr_camera = nodes
				print("[AVRE - TeleportManager] XRCamera3D found.")
			if nodes is XRNode3D:
				if nodes.tracker == "left_hand":
					for subnodes in nodes.get_children():
						if subnodes is XRToolsFunctionPointer:
							xr_left_function_pointer = subnodes
							print("[AVRE - TeleportManager] XR Left Controller FunctionPointer found.")
				elif nodes.tracker == "right_hand":
					for subnodes in nodes.get_children():
						if subnodes is XRToolsFunctionPointer:
							xr_right_function_pointer = subnodes
							print("[AVRE - TeleportManager] XR Right Controller FunctionPointer found.")
							
func _connect_controller_buttons() -> void:
	if is_instance_valid(_controller_left_node) and is_instance_valid(_controller_right_node):
		_controller_left_node.button_pressed.connect(_on_teleporter_button_pressed.bind(_controller_left_node))
		_controller_left_node.button_released.connect(_on_teleporter_button_released.bind(_controller_left_node))
		_controller_right_node.button_pressed.connect(_on_teleporter_button_pressed.bind(_controller_right_node))
		_controller_right_node.button_released.connect(_on_teleporter_button_released.bind(_controller_right_node))
	
func _on_teleporter_button_pressed(p_button : String, controller : XRController3D) -> void:
	if p_button == teleporter_trigger_button and is_instance_valid(pointing_at):
		if controller == active_controller:
			if pointing_at.teleporter_enabled:
				teleport_called = true
		else:
			active_controller = controller


func _on_teleporter_button_released(p_button : String, controller : XRController3D) -> void:
	if p_button == teleporter_trigger_button:
		pointing_at = null

func _fade_out():
	if is_instance_valid(fade_mesh):
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.set_parallel(true)
		tween.tween_property(fade_mesh.get_surface_override_material(0), "shader_parameter/albedo", Color(0,0,0,1), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished

func _fade_in():
	if is_instance_valid(fade_mesh):
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.set_parallel(true)
		tween.tween_property(fade_mesh.get_surface_override_material(0), "shader_parameter/albedo", Color(0,0,0,0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		
					
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if current_location == null:
		warnings.append("No starting point yet for the player. Please set a starting teleporter.")
	if xr_origin == null:
		warnings.append("No XROrigin3D detected. Please ensure you have an XRPlayer node.")
	if xr_left_function_pointer == null:
		warnings.append("The left controller does not have a FunctionPointer node. Please add a FunctionPointer.")
	if xr_right_function_pointer == null:
		warnings.append("The right controller does not have a FunctionPointer node. Please add a FunctionPointer.")
	if fade_mesh == null:
		warnings.append("No fademesh set for teleportation transition.")
	# Return warnings
	return warnings
	

	
