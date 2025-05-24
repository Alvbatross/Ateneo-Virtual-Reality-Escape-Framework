@tool
extends Node


signal start_events()

const EVENT_MANAGER_DEFAULTS_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/event_manager_defaults.json"
const EVENT_MANAGER_SETTINGS_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/event_manager_params.json"
const EVENT_LIBRARY_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/event_library.json"
const QUEST_LIBRARY_PATH := "res://addons/ateneo-virtual-reality-escape/event-management-system/data/quest_library.json"

var all_possible_flags : Array = []

var event_manager_defaults : Dictionary = {}
var event_manager_settings : Dictionary = {}

var event_library : Dictionary = {}
var quest_library : Dictionary = {}

var completed_events : Array = []



func _ready() -> void:
	load_event_settings()
	load_event_library()
	load_quest_library()



func _on_event_ended() -> void:
	print("-----------------------------")
	print(" STARTING ALL EVENTS")
	print("-----------------------------")
	await get_tree().create_timer(0.1).timeout
	emit_signal("start_events")


func update_active_quests() -> void:
	pass



func add_new_parameter(parameter_name : String, parameter_type : Variant) -> void:
	event_manager_settings["Parameters"][parameter_name] = parameter_type
	save_event_settings()
	for e in event_library:
		event_library[e][parameter_name] = parameter_type


func add_new_category(category_name : String) -> void:
	event_manager_settings["Categories"].append(category_name)
	save_event_settings()


func add_new_event(event_name : String) -> void:
	event_library[event_name] = {}
	
	var ems = event_manager_settings.duplicate(true)
	
	for param in event_manager_settings["Parameters"]:
		if !param == "EventName":
			event_library[event_name][param] = ems["Parameters"][param]
			if param == "EventCompletionFlags":
				event_library[event_name][param].append(event_name + "_Done")
				
	save_event_library()


func add_new_quest(quest_name : String) -> void:
	quest_library[quest_name] = {}
	
	var ems = event_manager_settings.duplicate(true)
	
	for param in event_manager_settings["QuestParameters"]:
		if !param == "QuestName":
			quest_library[quest_name][param] = ems["QuestParameters"][param]
			if param == "QuestCompletionFlags":
				quest_library[quest_name][param].append(quest_name + "_Done")
	
	save_quest_library()


func save_event_library() -> void:
	var save_path := EVENT_LIBRARY_PATH
	
	var data := event_library
	
	var data_string = JSON.stringify(data, "\t", false)
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(data_string)
	save_file.flush()
	save_file.close()
	
	update_all_flags()


func load_event_library() -> void:
	var load_path := EVENT_LIBRARY_PATH
	var data : Dictionary 
	var load_file
	
	if FileAccess.file_exists(load_path):
		load_file = FileAccess.get_file_as_string(load_path)
		
		print("--EVENT SYSTEM-- LOADED EVENT LIBRARY")
		
		data = JSON.parse_string(load_file)
	else:
		print("--EVENT SYSTEM-- NO EVENT LIBRARY FOUND")
		return
	
	event_library = data
	
	print(event_library)
	
	update_all_flags()


func update_all_flags() -> void:
	all_possible_flags.clear()
	for event in event_library:
		if !event + "_Done" in all_possible_flags:
			all_possible_flags.append(event + "_Done")
		for flag in event_library[event]["EventPrerequisiteFlags"]:
			if !flag in all_possible_flags:
				all_possible_flags.append(flag)
		for flag in event_library[event]["EventCompletionFlags"]:
			if !flag in all_possible_flags:
				all_possible_flags.append(flag)
	for quest in quest_library:
		if !quest + "_Done" in all_possible_flags:
			all_possible_flags.append(quest + "_Done")
		for flag in quest_library[quest]["QuestCompletionFlags"]:
			if !flag in all_possible_flags:
				all_possible_flags.append(flag)

func save_quest_library() -> void:
	var save_path := QUEST_LIBRARY_PATH
	
	var data := quest_library
	
	var data_string = JSON.stringify(data, "\t", false)
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(data_string)
	save_file.flush()
	save_file.close()
	
	update_all_flags()


func load_quest_library() -> void:
	var load_path := QUEST_LIBRARY_PATH
	var data : Dictionary 
	var load_file
	
	if FileAccess.file_exists(load_path):
		load_file = FileAccess.get_file_as_string(load_path)
		
		print("--EVENT SYSTEM-- LOADED QUEST LIBRARY")
		
		data = JSON.parse_string(load_file)
	else:
		print("--EVENT SYSTEM-- NO QUEST LIBRARY FOUND")
		return
	
	quest_library = data
	
	print(quest_library)
	
	update_all_flags()


func save_event_settings() -> void:
	var save_path := EVENT_MANAGER_SETTINGS_PATH
	
	var data = event_manager_settings
	
	var data_string = JSON.stringify(data, "\t", false)
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_line(data_string)
	save_file.flush()
	save_file.close()


func load_event_settings() -> void:
	var load_path := EVENT_MANAGER_SETTINGS_PATH
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
	
	event_manager_settings = data
	print(event_manager_settings)
	
	load_path = EVENT_MANAGER_DEFAULTS_PATH
	load_file = FileAccess.get_file_as_string(load_path)
	
	event_manager_defaults = JSON.parse_string(load_file)
	print(event_manager_defaults)
