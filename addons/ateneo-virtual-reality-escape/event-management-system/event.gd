@tool
class_name Event
extends Node


signal event_started()
signal event_ended()


@export var event_name : String
var event_category : String
var event_prerequisite_flags : Array
var event_completion_flags : Array
var oneshot : bool

var prerequisites_done : bool = true
var is_ongoing : bool = false


func _ready() -> void:
	initialize_event()
	
	EventManager.start_events.connect(start_event)
	
	event_started.connect(_on_event_started)
	event_ended.connect(EventManager._on_event_ended)
	


func initialize_event() -> void:
	self.name = event_name
	if EventManager.event_library.has(event_name):
		event_category = EventManager.event_library[event_name]["EventCategory"]
		event_prerequisite_flags = EventManager.event_library[event_name]["EventPrerequisiteFlags"]
		event_completion_flags = EventManager.event_library[event_name]["EventCompletionFlags"]
		oneshot = EventManager.event_library[event_name]["Oneshot"]
	else:
		print("Event " + event_name + " Not Found")


func start_event() -> void:
	prerequisites_done = true
	for flag in event_prerequisite_flags:
		if flag not in EventManager.completed_events:
			prerequisites_done = false
	
	if not prerequisites_done:
		print("Event " + event_name + " Not Started")
		is_ongoing = true
		emit_signal("event_started")


func close_event() -> void:
	for flag in event_completion_flags:
		if not EventManager.completed_events.has(flag):
			EventManager.completed_events.append(flag)
	
	emit_signal("event_ended")

func _on_event_started() -> void:
	pass
