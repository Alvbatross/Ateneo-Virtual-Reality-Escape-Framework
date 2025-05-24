@tool
class_name Quest
extends Node

signal quest_started()
signal quest_updated()
signal quest_ended()

var quest_name : String
var quest_description : Dictionary
var quest_completion_tracker : Dictionary
var quest_completion_flags : Array
var quest_completion_requirements : Array
@export_range(0.0, 1.0) var quest_progress : float = 0


func _ready() -> void:
	quest_ended.connect(EventManager.update_active_quests)
	quest_progress = 0.0

func initialize_quest() -> void:
	quest_name = name
	if EventManager.quest_library.has(quest_name):
		quest_description = EventManager.quest_library[quest_name]["QuestDescription"]
		quest_completion_tracker = EventManager.quest_library[quest_name]["QuestCompletionTracker"]
		quest_completion_flags = EventManager.quest_library[quest_name]["QuestCompletionFlags"]
		print("Quest " + quest_name + " Started")
	else:
		print("Quest " + quest_name + " Not Found")
	
	for req in quest_completion_tracker:
		for event in quest_completion_tracker[req]:
			quest_completion_requirements.append(event)
	
	print(quest_completion_tracker)
	
	update_quest()
	emit_signal("quest_started", name)


func update_quest() -> void:
	var iterator : int = 0
	for reqs in quest_completion_tracker:
		for event in quest_completion_tracker[reqs]:
			if event in EventManager.completed_events:
				iterator += 1
	
	emit_signal("quest_updated", name)
	quest_progress = float(iterator) / float(quest_completion_requirements.size())
	print(quest_description["Name"] + " " + str(snapped((quest_progress * 100), 0.01)) + "% Complete")
	if quest_progress >= 1.0:
		end_quest()

func end_quest() -> void:
	for flag in quest_completion_flags:
		EventManager.completed_events.append(flag)
	queue_free()
	print(EventManager.completed_events)
	await tree_exited
	emit_signal("quest_ended", name)
