@tool
class_name Event
extends Node


signal event_started()
signal event_ended()


@export var event_name : String:
	set(e_name):
		if e_name != event_name:
			event_name = e_name
			_update_event_name()


var event_category : String
var event_prerequisite_flags : Array
var event_completion_flags : Array
var oneshot : bool
var custom_parameters : Dictionary = {}

var prerequisites_done : bool = true
var is_ongoing : bool = false


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	initialize_event()
	is_ongoing = false
	
	if event_name in EventManager.completed_events:
		self.queue_free()
		return
	
	EventManager.start_events.connect(start_event)
	
	event_started.connect(_on_event_started)
	event_ended.connect(EventManager._on_event_ended)
	
	start_event()


func initialize_event() -> void:
	self.name = event_name
	if EventManager.event_library.has(event_name):
		for param in EventManager.event_library[event_name]:
			if param == "EventCategory":
				event_category = EventManager.event_library[event_name]["EventCategory"]
			elif param == "EventPrerequisiteFlags":
				event_prerequisite_flags = EventManager.event_library[event_name]["EventPrerequisiteFlags"]
			elif param == "EventCompletionFlags":
				event_completion_flags = EventManager.event_library[event_name]["EventCompletionFlags"]
			elif param == "Oneshot":
				oneshot = EventManager.event_library[event_name]["Oneshot"]
			else:
				custom_parameters[param] = EventManager.event_library[event_name][param]
	else:
		print("Event " + event_name + " Not Found")
	
	#print(custom_parameters)


func start_event() -> void:
	if is_ongoing:
		return
	prerequisites_done = true
	for flag in event_prerequisite_flags:
		if flag not in EventManager.completed_events:
			prerequisites_done = false
	
	if not prerequisites_done:
		print("Event " + event_name + " Not Started")
	else:
		print("Event " + event_name + " Started")
		is_ongoing = true
		emit_signal("event_started")


func close_event() -> void:
	for flag in event_completion_flags:
		if not EventManager.completed_events.has(flag):
			EventManager.completed_events.append(flag)
	
	print(EventManager.completed_events)
	
	queue_free()
	emit_signal("event_ended")
	await tree_exited


func _update_event_name() -> void:
	if event_name != "":
		self.name = event_name
	else:
		self.name = "Event"


func _on_event_started() -> void:
	pass
