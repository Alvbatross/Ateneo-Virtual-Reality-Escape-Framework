@tool
extends Node


signal start_events()

var EVENT_MANAGER_DEFAULTS_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/event_manager_defaults.json"
var EVENT_MANAGER_PARAMS_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/event_manager_params.json"

var event_manager_params : Dictionary = {}
var event_categories : Array = []

var event_library : Dictionary = {}
var quest_library : Dictionary = {}

var completed_events : Array = []



func _ready() -> void:
	load_event_parameters()


func _on_event_ended() -> void:
	await get_tree().create_timer(0.1).timeout
	emit_signal("start_events")


func add_new_parameter(parameter_name : String, parameter_type : Variant) -> void:
	event_manager_params[parameter_name] = parameter_type
	save_event_parameters()
	for e in event_library:
		event_library[e][parameter_name] = parameter_type


func add_new_event(event_name : String) -> void:
	event_library[event_name] = {}
	
	for param in event_manager_params:
		if !param == "EventName":
			event_library[event_name][param] = event_manager_params[param]
	
	print(event_library)


func save_event_parameters() -> void:
	var save_path := EVENT_MANAGER_PARAMS_PATH
	
	var data = event_manager_params
	
	print(data)
	var data_string = JSON.stringify(data, "\t", false)
	print(data_string)
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(data_string)
	save_file.flush()
	save_file.close()
	print("This is happening")


func load_event_parameters() -> void:
	var load_path := EVENT_MANAGER_PARAMS_PATH
	var data : Dictionary 
	var load_file
	if FileAccess.file_exists(load_path):
		load_file = FileAccess.get_file_as_string(load_path)
		
		print("--EVENT SYSTEM-- LOADED EVENT MANAGER PARAMETERS")
		
		data = JSON.parse_string(load_file)
	else:
		load_path = EVENT_MANAGER_DEFAULTS_PATH
		load_file = FileAccess.get_file_as_string(load_path)
		
		print("--EVENT SYSTEM-- LOADED EVENT MANAGER DEFAULT PARAMETERS")
		
		data = JSON.parse_string(load_file)
	
	event_manager_params = data
	
	
