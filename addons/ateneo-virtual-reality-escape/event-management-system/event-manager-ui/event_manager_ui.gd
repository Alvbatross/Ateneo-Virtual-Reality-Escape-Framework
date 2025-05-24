@tool
class_name EventManagerUI
extends Control

@export var dictionary : Dictionary

@onready var add_parameter_db := $AddParameterDB
@onready var add_parameter_name := $AddParameterDB/VBoxContainer/LineEdit
@onready var add_parameter_type := $AddParameterDB/VBoxContainer/OptionButton

@onready var add_event_db := $AddEventDB
@onready var add_event_name := $AddEventDB/VBoxContainer/LineEdit

@onready var add_quest_db := $AddQuestDB
@onready var add_quest_name := $AddQuestDB/VBoxContainer/LineEdit

@onready var add_event_category_db := $AddEventCategoryDB
@onready var add_event_category_name := $AddEventCategoryDB/VBoxContainer/LineEdit

@onready var event_prerequisite_viewer_db := $EventPrerequisiteViewerDB
@onready var event_prerequisite_name := $EventPrerequisiteViewerDB/VBoxContainer/EventName
@onready var event_prerequisite_text := $EventPrerequisiteViewerDB/VBoxContainer/RichTextLabel
@onready var event_prerequisite_option := $EventPrerequisiteViewerDB/VBoxContainer/AddAdditionalPrerequisites
@onready var event_add_prerequisite_button := $EventPrerequisiteViewerDB/VBoxContainer/AddPrerequisite
@onready var event_remove_option := $EventPrerequisiteViewerDB/VBoxContainer/PrerequisiteList
@onready var event_remove_button := $EventPrerequisiteViewerDB/VBoxContainer/RemovePrerequisite

@onready var event_completion_viewer_db := $EventCompletionViewerDB
@onready var event_completion_name := $EventCompletionViewerDB/VBoxContainer/EventName
@onready var event_completion_text := $EventCompletionViewerDB/VBoxContainer/RichTextLabel
@onready var add_existing_option := $EventCompletionViewerDB/VBoxContainer/HBoxContainer2/OptionButton
@onready var add_custom_option := $EventCompletionViewerDB/VBoxContainer/HBoxContainer2/LineEdit
@onready var add_existing_option_button := $EventCompletionViewerDB/VBoxContainer/HBoxContainer/AddExisting
@onready var add_custom_option_button := $EventCompletionViewerDB/VBoxContainer/HBoxContainer/AddCustom
@onready var remove_completion_option := $EventCompletionViewerDB/VBoxContainer/HBoxContainer3/OptionButton
@onready var remove_completion_option_button := $EventCompletionViewerDB/VBoxContainer/HBoxContainer3/RemoveCompletion

@onready var remove_db := $RemoveDB
@onready var remove_label := $RemoveDB/VBoxContainer/Label
@onready var remove_option := $RemoveDB/VBoxContainer/OptionButton

@onready var custom_array_dictionary_db := $CustomArrayDictionaryViewerDB
@onready var custom_array_dictionary_text := $CustomArrayDictionaryViewerDB/VBoxContainer/CodeEdit
@onready var custom_array_dictionary_save_button := $CustomArrayDictionaryViewerDB/VBoxContainer/SaveEdits

@onready var quest_description_viewer_db := $QuestDescriptionViewerDB
@onready var quest_description_viewer_name := $QuestDescriptionViewerDB/VBoxContainer/QuestNameEdit
@onready var quest_description_viewer_desc := $QuestDescriptionViewerDB/VBoxContainer/TextEdit

@onready var quest_tracker_viewer_db := $QuestTrackerViewerDB
@onready var quest_tracker_viewer_option := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer/VBoxContainer/RequirementList
@onready var quest_tracker_edit_req_text := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer/VBoxContainer2/EditRequirementText
@onready var quest_tracker_new_req_text := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer/VBoxContainer3/NewRequirementText
@onready var quest_tracker_new_req_button := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer/VBoxContainer3/AddRequirement
@onready var quest_tracker_req_events_text := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer2/RichTextLabel
@onready var quest_tracker_req_events_option := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer2/HBoxContainer/EventList
@onready var quest_tracker_add_req_events_button := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer2/HBoxContainer2/AddRequiredEvent
@onready var quest_tracker_remove_events_option := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer2/HBoxContainer/RequiredEventList
@onready var quest_tracker_remove_events_button := $QuestTrackerViewerDB/HBoxContainer/VBoxContainer2/HBoxContainer2/RemoveRequiredEvent

@onready var quest_completion_viewer_db := $QuestCompletionViewerDB
@onready var quest_completion_name := $QuestCompletionViewerDB/VBoxContainer/QuestName
@onready var quest_completion_flags_text := $QuestCompletionViewerDB/VBoxContainer/RichTextLabel
@onready var quest_completion_add_existing_flags_option := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer2/OptionButton
@onready var quest_completion_add_custom_flags_line := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer2/LineEdit
@onready var quest_completion_add_existing_flags_button := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer/AddExisting
@onready var quest_completion_add_custom_flags_button := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer/AddCustom
@onready var quest_completion_remove_flags_option := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer3/OptionButton
@onready var quest_completion_remove_flags_button := $QuestCompletionViewerDB/VBoxContainer/HBoxContainer3/RemoveCompletion

@onready var parameters := $TabContainer/EventEditor/VBoxContainer/ScrollContainer/VBoxContainer/Parameters

@onready var quest_parameters := $TabContainer/QuestEditor/VBoxContainer/ScrollContainer/VBoxContainer/QuestParameters

var currently_editing_event_name : String = ""
var currently_editing_event_index : int = 0
var new_event_name : String = ""

var currently_removing_category : String = ""

var currently_editing_line : String = ""

var currently_editing_quest_description : String = ""

var currently_editing_quest_requirement_idx : int = 0
var currently_editing_quest_requirement : String = ""
var new_quest_requirement_text : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parameters.add_spacer(false)
	refresh_quest_parameters()
	refresh_event_parameters()
	refresh_events()
	refresh_quests()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parameters.get_child_count() == 0:
		refresh_event_parameters()
		refresh_events()
	if quest_parameters.get_child_count() == 0:
		refresh_quest_parameters()
		refresh_quests()


func refresh_event_parameters() -> void:
	for child in parameters.get_children():
		child.free()
	var i = 0
	for p in EventManager.event_manager_settings["Parameters"]:
		var vbox = VBoxContainer.new()
		vbox.ALIGNMENT_CENTER
		parameters.add_child(vbox)
		var label = Label.new()
		label.text = p
		parameters.get_child(i).add_child(label)
		label.custom_minimum_size.x = label.size.x + 40
		i += 1


func refresh_events() -> void:
	for child in parameters.get_children():
		for c in child.get_children():
			if !c.get_index() == 0:
				c.free()
	for e in EventManager.event_library:
		for param in parameters.get_children():
			if param.get_child(0).text == "EventName":
				var line_edit = LineEdit.new()
				line_edit.text = e
				param.add_child(line_edit)
				line_edit.focus_entered.connect(_on_event_name_edit_focus_entered.bind(line_edit.text, line_edit.get_index()))
				line_edit.focus_exited.connect(_on_event_name_edit_focus_exited)
				line_edit.text_changed.connect(_on_event_name_edit_text_changed)
				line_edit.custom_minimum_size.x = line_edit.size.x * 3
				line_edit.custom_minimum_size.y = 31
			elif param.get_child(0).text == "EventCategory":
				var option_button = OptionButton.new()
				for cat in EventManager.event_manager_settings["Categories"]:
					option_button.add_item(cat)
				option_button.select(EventManager.event_manager_settings["Categories"].find(EventManager.event_library[e]["EventCategory"]))
				param.add_child(option_button)
				option_button.item_selected.connect(_on_event_category_item_selected.bind(option_button.get_index(), option_button))
				option_button.custom_minimum_size.y = 31
			else:
				if typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_STRING or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_FLOAT or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_INT:
					var line_edit = LineEdit.new()
					line_edit.text = str(EventManager.event_library[e][param.get_child(0).text])
					param.add_child(line_edit)
					line_edit.focus_entered.connect(_on_custom_line_edit_focus_entered.bind(line_edit.text, param.get_child(0).text, line_edit.get_index()))
					line_edit.focus_exited.connect(_on_custom_line_edit_focus_exited.bind(param.get_child(0).text, line_edit.get_index()))
					line_edit.text_changed.connect(_on_custom_line_edit_text_changed)
					line_edit.custom_minimum_size.y = 31
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_BOOL:
					var check_box = CheckBox.new()
					check_box.button_pressed = EventManager.event_library[e][param.get_child(0).text]
					param.add_child(check_box)
					check_box.toggled.connect(_on_event_checkbox_toggled.bind(param.get_child(0).text, check_box.get_index()))
					check_box.custom_minimum_size.y = 31
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_DICTIONARY:
					var view_button = Button.new()
					view_button.text = "View " + param.get_child(0).text
					param.add_child(view_button)
					view_button.pressed.connect(_on_custom_array_dictionary_param_pressed.bind(param.get_child(0).text, "Dictionary", view_button.get_index()))
					view_button.custom_minimum_size.y = 31
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_ARRAY:
					var view_button = Button.new()
					view_button.text = "View " + param.get_child(0).text
					param.add_child(view_button)
					if param.get_child(0).text == "EventPrerequisiteFlags":
						view_button.pressed.connect(_on_view_prerequisites_pressed.bind(view_button.get_index()))
					elif param.get_child(0).text == "EventCompletionFlags":
						view_button.pressed.connect(_on_view_completion_pressed.bind(view_button.get_index()))
					else:
						view_button.pressed.connect(_on_custom_array_dictionary_param_pressed.bind(param.get_child(0).text, "Array", view_button.get_index()))
					view_button.custom_minimum_size.y = 31


func refresh_quest_parameters() -> void:
	for child in quest_parameters.get_children():
		child.free()
	var i = 0
	for p in EventManager.event_manager_settings["QuestParameters"]:
		var vbox = VBoxContainer.new()
		vbox.ALIGNMENT_CENTER
		quest_parameters.add_child(vbox)
		var label = Label.new()
		label.text = p
		quest_parameters.get_child(i).add_child(label)
		label.custom_minimum_size.x = label.size.x + 40
		i += 1


func refresh_quests() -> void:
	for child in quest_parameters.get_children():
		for c in child.get_children():
			if !c.get_index() == 0:
				c.free()
	
	for q in EventManager.quest_library:
		for param in quest_parameters.get_children():
			if param.get_child(0).text == "QuestName":
				var line_edit = LineEdit.new()
				line_edit.text = q
				param.add_child(line_edit)
				line_edit.focus_entered.connect(_on_quest_name_edit_focus_entered.bind(line_edit.text, line_edit.get_index()))
				line_edit.focus_exited.connect(_on_quest_name_edit_focus_exited)
				line_edit.text_changed.connect(_on_quest_name_text_changed)
				line_edit.custom_minimum_size.x = line_edit.size.x * 3
				line_edit.custom_minimum_size.y = 30
			elif param.get_child(0).text == "QuestDescription":
				var button = Button.new()
				button.text = "View " + param.get_child(0).text
				param.add_child(button)
				button.pressed.connect(_on_quest_description_button_pressed.bind(button.get_index()))
				button.custom_minimum_size.y = 30
			elif param.get_child(0).text == "QuestCompletionTracker":
				var button = Button.new()
				button.text = "View " + param.get_child(0).text
				param.add_child(button)
				button.pressed.connect(_on_quest_tracker_viewer_button_pressed.bind(button.get_index()))
				button.custom_minimum_size.y = 30
			elif param.get_child(0).text == "QuestCompletionFlags":
				var button = Button.new()
				button.text = "View " + param.get_child(0).text
				param.add_child(button)
				button.pressed.connect(_on_view_quest_completion_pressed.bind(button.get_index()))
				button.custom_minimum_size.y = 30


#---------------------------------------------------------------------------
#     ADD/REMOVE BUTTON FUNCTIONS
#---------------------------------------------------------------------------

func _on_add_event_pressed() -> void:
	add_event_name.text = ""
	add_event_db.visible = true


func _on_add_event_parameter_pressed() -> void:
	add_parameter_name.text = ""
	add_parameter_type.selected = -1
	add_parameter_db.visible = true


func _on_add_event_category_pressed() -> void:
	add_event_category_name.text = ""
	add_event_category_db.visible = true


func _on_remove_event_pressed() -> void:
	open_remove_db("Event")


func _on_remove_event_category_pressed() -> void:
	open_remove_db("Category")


func _on_remove_event_parameter_pressed() -> void:
	open_remove_db("Parameter")


func _on_remove_quest_pressed() -> void:
	open_remove_db("Quest")
	

func open_remove_db(remove_cat : String) -> void:
	remove_option.clear()
	currently_removing_category = remove_cat
	match remove_cat:
		"Event" :
			remove_db.title = "Remove Event"
			remove_label.text = "Event:"
			for event in EventManager.event_library:
				remove_option.add_item(event)
		"Category" :
			remove_db.title = "Remove Category"
			remove_label.text = "Category:"
			for category in EventManager.event_manager_settings["Categories"]:
				if not category in EventManager.event_manager_defaults["Categories"]:
					remove_option.add_item(category)
		"Parameter" :
			remove_db.title = "Remove Parameter"
			remove_label.text = "Parameter:"
			for param in EventManager.event_manager_settings["Parameters"]:
					if not param in EventManager.event_manager_defaults["Parameters"]:
						remove_option.add_item(param)
		"Quest" :
			remove_db.title = "Remove Quest"
			remove_label.text = "Quest:"
			for quest in EventManager.quest_library:
				remove_option.add_item(quest)
	
	remove_db.visible = true


func _on_add_parameter_db_confirmed() -> void:
	match add_parameter_type.selected:
		0:
			EventManager.add_new_parameter(add_parameter_name.text, int(0))
		1:
			EventManager.add_new_parameter(add_parameter_name.text, float(0.0))
		2:
			EventManager.add_new_parameter(add_parameter_name.text, false)
		3:
			EventManager.add_new_parameter(add_parameter_name.text, "")
		4:
			EventManager.add_new_parameter(add_parameter_name.text, [])
		5:
			EventManager.add_new_parameter(add_parameter_name.text, {})
	
	EventManager.save_event_library()
	refresh_event_parameters()
	refresh_events()


func _on_add_event_db_confirmed() -> void:
	EventManager.add_new_event(add_event_name.text)
	refresh_events()


func _on_add_event_category_db_confirmed() -> void:
	EventManager.add_new_category(add_event_category_name.text)
	refresh_events()


func _on_remove_db_confirmed() -> void:
	match currently_removing_category:
		"Event":
			EventManager.event_library.erase(remove_option.get_item_text(remove_option.selected))
			for event in EventManager.event_library:
				EventManager.event_library[event]["EventPrerequisiteFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
				EventManager.event_library[event]["EventCompletionFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
			for quest in EventManager.quest_library:
				EventManager.quest_library[quest]["QuestCompletionFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
		"Category":
			EventManager.event_manager_settings["Categories"].erase(remove_option.get_item_text(remove_option.selected))
		"Parameter":
			EventManager.event_manager_settings["Parameters"].erase(remove_option.get_item_text(remove_option.selected))
			for event in EventManager.event_library:
				EventManager.event_library[event].erase(remove_option.get_item_text(remove_option.selected))
		"Quest":
			EventManager.quest_library.erase(remove_option.get_item_text(remove_option.selected))
			for event in EventManager.event_library:
				EventManager.event_library[event]["EventPrerequisiteFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
				EventManager.event_library[event]["EventCompletionFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
			for quest in EventManager.quest_library:
				EventManager.quest_library[quest]["QuestCompletionFlags"].erase(remove_option.get_item_text(remove_option.selected) + "_Done")
	
	#print(EventManager.event_manager_settings)
	#print(EventManager.event_library)
	EventManager.save_event_library()
	EventManager.save_quest_library()
	EventManager.save_event_settings()
	refresh_event_parameters()
	refresh_events()
	refresh_quest_parameters()
	refresh_quests()


func _on_add_quest_pressed() -> void:
	add_quest_name.text = ""
	add_quest_db.visible = true





func _on_add_quest_db_confirmed() -> void:
	EventManager.add_new_quest(add_quest_name.text)
	refresh_quests()


#---------------------------------------------------------------------------
#     VIEW EVENT PREREQUISITES FUNCTIONS
#---------------------------------------------------------------------------

func _on_view_prerequisites_pressed(index: int) -> void:
	event_prerequisite_text.clear()
	
	event_add_prerequisite_button.pressed.connect(_on_add_prerequisite_pressed.bind(index))
	event_remove_button.pressed.connect(_on_remove_prerequisite_pressed.bind(index))
	
	event_prerequisite_name.text = "Event: " + parameters.get_child(0).get_child(index).text
	
	for prereqs in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventPrerequisiteFlags"]:
		event_prerequisite_text.append_text(prereqs + "\n")
	
	event_prerequisite_option.clear()
	#print(EventManager.all_possible_flags)
	for prereq in EventManager.all_possible_flags:
		if not prereq in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventPrerequisiteFlags"] and not prereq == parameters.get_child(0).get_child(index).text + "_Done":
			event_prerequisite_option.add_item(prereq)
	
	event_remove_option.clear()
	for prereq in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventPrerequisiteFlags"]:
		event_remove_option.add_item(prereq)
	
	event_prerequisite_viewer_db.visible = true


func _on_add_prerequisite_pressed(index: int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventPrerequisiteFlags"].append(event_prerequisite_option.get_item_text(event_prerequisite_option.selected))
	if event_add_prerequisite_button.pressed.is_connected(_on_add_prerequisite_pressed):
		event_add_prerequisite_button.pressed.disconnect(_on_add_prerequisite_pressed)
	if event_remove_button.pressed.is_connected(_on_remove_prerequisite_pressed):
		event_remove_button.pressed.disconnect(_on_remove_prerequisite_pressed)
	_on_view_prerequisites_pressed(index)


func _on_event_prerequisite_viewer_db_close_requested() -> void:
	if event_add_prerequisite_button.pressed.is_connected(_on_add_prerequisite_pressed):
		event_add_prerequisite_button.pressed.disconnect(_on_add_prerequisite_pressed)
	if event_remove_button.pressed.is_connected(_on_remove_prerequisite_pressed):
		event_remove_button.pressed.disconnect(_on_remove_prerequisite_pressed)


func _on_event_prerequisite_viewer_db_confirmed() -> void:
	if event_add_prerequisite_button.pressed.is_connected(_on_add_prerequisite_pressed):
		event_add_prerequisite_button.pressed.disconnect(_on_add_prerequisite_pressed)
	if event_remove_button.pressed.is_connected(_on_remove_prerequisite_pressed):
		event_remove_button.pressed.disconnect(_on_remove_prerequisite_pressed)
	EventManager.save_event_library()


func _on_remove_prerequisite_pressed(index: int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventPrerequisiteFlags"].erase(event_remove_option.get_item_text(event_remove_option.selected))
	if event_add_prerequisite_button.pressed.is_connected(_on_add_prerequisite_pressed):
		event_add_prerequisite_button.pressed.disconnect(_on_add_prerequisite_pressed)
	if event_remove_button.pressed.is_connected(_on_remove_prerequisite_pressed):
		event_remove_button.pressed.disconnect(_on_remove_prerequisite_pressed)
	_on_view_prerequisites_pressed(index)


#---------------------------------------------------------------------------
#     VIEW EVENT COMPLETION FLAGS FUNCTIONS
#---------------------------------------------------------------------------

func _on_view_completion_pressed(index: int) -> void:
	event_completion_text.clear()
	
	add_existing_option_button.pressed.connect(_on_add_existing_pressed.bind(index))
	add_custom_option_button.pressed.connect(_on_add_custom_pressed.bind(index))
	remove_completion_option_button.pressed.connect(_on_remove_completion_pressed.bind(index))
	
	event_completion_name.text = "Event: " + parameters.get_child(0).get_child(index).text
	
	for flag in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"]:
		event_completion_text.append_text(flag + "\n")
	
	add_existing_option.clear()
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"]:
			if flag.find("_Done") < 0:
				add_existing_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) in EventManager.event_library and not flag.erase(flag.find("_Done"), 5) in EventManager.quest_library:
				add_existing_option.add_item(flag)
	
	add_custom_option.clear()
	
	remove_completion_option.clear()
	for flag in EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"]:
		if flag.find("_Done") < 0:
			remove_completion_option.add_item(flag)
		elif not flag.erase(flag.find("_Done"), 5) == parameters.get_child(0).get_child(index).text:
			remove_completion_option.add_item(flag)
	
	event_completion_viewer_db.visible = true


func _on_add_existing_pressed(index: int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"].append(add_existing_option.get_item_text(add_existing_option.selected))
	if add_existing_option_button.pressed.is_connected(_on_add_existing_pressed):
		add_existing_option_button.pressed.disconnect(_on_add_existing_pressed)
	if add_custom_option_button.pressed.is_connected(_on_add_custom_pressed):
		add_custom_option_button.pressed.disconnect(_on_add_custom_pressed)
	if remove_completion_option_button.pressed.is_connected(_on_remove_completion_pressed):
		remove_completion_option_button.pressed.disconnect(_on_remove_completion_pressed)
	_on_view_completion_pressed(index)


func _on_add_custom_pressed(index : int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"].append(add_custom_option.text)
	EventManager.update_all_flags()
	#print(EventManager.all_possible_flags)
	if add_existing_option_button.pressed.is_connected(_on_add_existing_pressed):
		add_existing_option_button.pressed.disconnect(_on_add_existing_pressed)
	if add_custom_option_button.pressed.is_connected(_on_add_custom_pressed):
		add_custom_option_button.pressed.disconnect(_on_add_custom_pressed)
	if remove_completion_option_button.pressed.is_connected(_on_remove_completion_pressed):
		remove_completion_option_button.pressed.disconnect(_on_remove_completion_pressed)
	_on_view_completion_pressed(index)


func _on_event_completion_viewer_db_close_requested() -> void:
	if add_existing_option_button.pressed.is_connected(_on_add_existing_pressed):
		add_existing_option_button.pressed.disconnect(_on_add_existing_pressed)
	if add_custom_option_button.pressed.is_connected(_on_add_custom_pressed):
		add_custom_option_button.pressed.disconnect(_on_add_custom_pressed)
	if remove_completion_option_button.pressed.is_connected(_on_remove_completion_pressed):
		remove_completion_option_button.pressed.disconnect(_on_remove_completion_pressed)


func _on_event_completion_viewer_db_confirmed() -> void:
	if add_existing_option_button.pressed.is_connected(_on_add_existing_pressed):
		add_existing_option_button.pressed.disconnect(_on_add_existing_pressed)
	if add_custom_option_button.pressed.is_connected(_on_add_custom_pressed):
		add_custom_option_button.pressed.disconnect(_on_add_custom_pressed)
	if remove_completion_option_button.pressed.is_connected(_on_remove_completion_pressed):
		remove_completion_option_button.pressed.disconnect(_on_remove_completion_pressed)
	EventManager.save_event_library()


func _on_remove_completion_pressed(index : int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text]["EventCompletionFlags"].erase(remove_completion_option.get_item_text(remove_completion_option.selected))
	if add_existing_option_button.pressed.is_connected(_on_add_existing_pressed):
		add_existing_option_button.pressed.disconnect(_on_add_existing_pressed)
	if add_custom_option_button.pressed.is_connected(_on_add_custom_pressed):
		add_custom_option_button.pressed.disconnect(_on_add_custom_pressed)
	if remove_completion_option_button.pressed.is_connected(_on_remove_completion_pressed):
		remove_completion_option_button.pressed.disconnect(_on_remove_completion_pressed)
	_on_view_completion_pressed(index)



#---------------------------------------------------------------------------
#     EDIT EVENT NAME FUNCTIONS
#---------------------------------------------------------------------------

func _on_event_name_edit_focus_entered(event_name : String, index : int) -> void:
	new_event_name = event_name
	currently_editing_event_name = event_name
	currently_editing_event_index = index
	#print(currently_editing_event_name)
	#print(currently_editing_event_index)


func _on_event_name_edit_focus_exited() -> void:
	var new_event_dictionary : Dictionary = {}

	for event in EventManager.event_library:
		if event == currently_editing_event_name:
			new_event_dictionary[new_event_name] = EventManager.event_library[event]
		else:
			new_event_dictionary[event] = EventManager.event_library[event]
			
	for event in new_event_dictionary:
		for prereq in new_event_dictionary[event]["EventPrerequisiteFlags"]:
			if prereq.find("_Done") < 0:
				pass
			elif currently_editing_event_name == prereq.erase(prereq.find("_Done"), 5):
				new_event_dictionary[event]["EventPrerequisiteFlags"][new_event_dictionary[event]["EventPrerequisiteFlags"].find(prereq)] = new_event_name + "_Done"
		for flag in new_event_dictionary[event]["EventCompletionFlags"]:
			if flag.find("_Done") < 0:
				pass
			elif currently_editing_event_name == flag.erase(flag.find("_Done"), 5):
				new_event_dictionary[event]["EventCompletionFlags"][new_event_dictionary[event]["EventCompletionFlags"].find(flag)] = new_event_name + "_Done"
	
	
	EventManager.event_library.clear()
	EventManager.event_library = new_event_dictionary.duplicate(true)
	EventManager.update_all_flags()
	call_deferred("refresh_events")
	EventManager.save_event_library()


func _on_event_name_edit_text_changed(new_text : String) -> void:
	new_event_name = new_text


#---------------------------------------------------------------------------
#     EDIT EVENT CATEGORY FUNCTION
#---------------------------------------------------------------------------

func _on_event_category_item_selected(item_index : int, event_index : int, option_button : OptionButton) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(event_index).text]["EventCategory"] = option_button.get_item_text(item_index)
	#print(EventManager.event_library)
	call_deferred("refresh_events")
	EventManager.save_event_library()

#---------------------------------------------------------------------------
#     EDIT CHECKBOX PARAMETER FUNCTION
#---------------------------------------------------------------------------

func _on_event_checkbox_toggled(toggled : bool, parameter : String, index : int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = toggled
	#print(EventManager.event_library)
	call_deferred("refresh_events")
	EventManager.save_event_library()

#---------------------------------------------------------------------------
#     Custom Array Param
#---------------------------------------------------------------------------

func _on_custom_array_dictionary_param_pressed(parameter : String, type : String, index : int) -> void:
	custom_array_dictionary_text.clear()
	custom_array_dictionary_save_button.pressed.connect(_on_save_edits_pressed.bind(parameter, type, index))
	
	custom_array_dictionary_text.text = str(EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter])
	
	custom_array_dictionary_db.visible = true


func _on_save_edits_pressed(parameter : String, type : String, index : int) -> void:
	var parsed_string = JSON.parse_string(custom_array_dictionary_text.text)
	if type == "Array":
		if parsed_string == null or not typeof(parsed_string) == TYPE_ARRAY:
			print("----------------------------------------------")
			print("SAVE FAILED - CANNOT PARSE TEXT TO ARRAY")
			print("----------------------------------------------")
		else:
			EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = parsed_string
	elif type == "Dictionary":
		if parsed_string == null or not typeof(parsed_string) == TYPE_DICTIONARY:
			print("----------------------------------------------")
			print("SAVE FAILED - CANNOT PARSE TEXT TO DICTIONARY")
			print("----------------------------------------------")
		else:
			EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = parsed_string
	
	call_deferred("refresh_events")
	EventManager.save_event_library()


func _on_custom_array_dictionary_viewer_db_confirmed() -> void:
	if custom_array_dictionary_save_button.pressed.is_connected(_on_save_edits_pressed):
		custom_array_dictionary_save_button.pressed.disconnect(_on_save_edits_pressed)


func _on_custom_array_dictionary_viewer_db_close_requested() -> void:
	if custom_array_dictionary_save_button.pressed.is_connected(_on_save_edits_pressed):
		custom_array_dictionary_save_button.pressed.disconnect(_on_save_edits_pressed)


func _on_custom_line_edit_focus_entered(line : String, parameter : String, index : int) -> void:
	currently_editing_line = line
	#print(parameter)
	#print(index)
	#
	#print(parameters.get_child(0).get_child(index).text)
	#print(parameters.get_child(0).get_child(index))

func _on_custom_line_edit_focus_exited(parameter : String, index : int) -> void:
	#print(parameter)
	#print(index)
	#print(parameters.get_child(0).get_child(index).text)
	#print(parameters.get_child(0).get_child(index))
	var editing_parameter = EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter]
	
	if typeof(editing_parameter) == TYPE_INT:
		if currently_editing_line.is_valid_int():
			EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = currently_editing_line.to_int()
		else:
			currently_editing_line = str(EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter])
	elif typeof(editing_parameter) == TYPE_FLOAT:
		if currently_editing_line.is_valid_float():
			EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = currently_editing_line.to_float()
		else:
			currently_editing_line = str(EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter])
	else:
		EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = str(currently_editing_line)
	
	
	EventManager.update_all_flags()
	call_deferred("refresh_events")
	EventManager.save_event_library()

func _on_custom_line_edit_text_changed(new_text : String) -> void:
	currently_editing_line = new_text



#---------------------------------------------------------------------------
#     Quest Description Functions
#---------------------------------------------------------------------------

func _on_quest_description_button_pressed(index : int) -> void:
	currently_editing_quest_description = quest_parameters.get_child(0).get_child(index).text
	quest_description_viewer_name.text = EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestDescription"]["Name"]
	quest_description_viewer_desc.text = EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestDescription"]["Description"]
	quest_description_viewer_db.visible = true


func _on_quest_description_viewer_db_confirmed() -> void:
	EventManager.quest_library[currently_editing_quest_description]["QuestDescription"]["Name"] = quest_description_viewer_name.text
	EventManager.quest_library[currently_editing_quest_description]["QuestDescription"]["Description"] = quest_description_viewer_desc.text
	EventManager.save_quest_library()
	call_deferred("refresh_quests")


#---------------------------------------------------------------------------
#     Quest Completion Tracker Functions
#---------------------------------------------------------------------------

func _on_quest_tracker_viewer_button_pressed(index : int) -> void:
	quest_tracker_viewer_option.clear()
	quest_tracker_req_events_option.clear()
	quest_tracker_remove_events_option.clear()
	
	currently_editing_quest_requirement_idx = index
	for req in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"]:
		quest_tracker_viewer_option.add_item(req)
	
	quest_tracker_edit_req_text.text = quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)
	quest_tracker_new_req_text.text = ""
	quest_tracker_req_events_text.text = ""
	
	for req_event in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(0)]:
		quest_tracker_req_events_text.append_text(req_event + "\n")
	
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(0)]:
			if flag.find("_Done") < 0:
				quest_tracker_req_events_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(index).text:
				quest_tracker_req_events_option.add_item(flag)
		
	for event in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(0)]:
		quest_tracker_remove_events_option.add_item(event)
	
	if quest_tracker_add_req_events_button.pressed.is_connected(_on_add_required_event_pressed):
		quest_tracker_add_req_events_button.pressed.disconnect(_on_add_required_event_pressed)
	
	if quest_tracker_remove_events_button.pressed.is_connected(_on_remove_required_event_pressed):
		quest_tracker_remove_events_button.pressed.disconnect(_on_remove_required_event_pressed)
	
	quest_tracker_add_req_events_button.pressed.connect(_on_add_required_event_pressed.bind(index))
	quest_tracker_remove_events_button.pressed.connect(_on_remove_required_event_pressed.bind(index))
	
	quest_tracker_viewer_db.visible = true


func _on_add_required_event_pressed(index : int) -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"][quest_tracker_edit_req_text.text].append(quest_tracker_req_events_option.get_item_text(quest_tracker_req_events_option.selected))
	EventManager.save_quest_library()
	
	quest_tracker_req_events_option.clear()
	quest_tracker_remove_events_option.clear()
	
	quest_tracker_req_events_text.text = ""
	
	for req_event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_req_events_text.append_text(req_event + "\n")
	
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
			if flag.find("_Done") < 0:
				quest_tracker_req_events_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text:
				quest_tracker_req_events_option.add_item(flag)
	
	for event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_remove_events_option.add_item(event)


func _on_remove_required_event_pressed(index : int) -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionTracker"][quest_tracker_edit_req_text.text].erase(quest_tracker_remove_events_option.get_item_text(quest_tracker_remove_events_option.selected))
	EventManager.save_quest_library()
	
	quest_tracker_req_events_option.clear()
	quest_tracker_remove_events_option.clear()
	
	quest_tracker_req_events_text.text = ""
	
	for req_event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_req_events_text.append_text(req_event + "\n")
	
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
			if flag.find("_Done") < 0:
				quest_tracker_req_events_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text:
				quest_tracker_req_events_option.add_item(flag)
	
	for event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_remove_events_option.add_item(event)


func _on_edit_requirement_text_text_changed(new_text: String) -> void:
	new_quest_requirement_text = new_text


func _on_edit_requirement_text_focus_entered() -> void:
	currently_editing_quest_requirement = quest_tracker_edit_req_text.text
	new_quest_requirement_text = quest_tracker_edit_req_text.text


func _on_edit_requirement_text_focus_exited() -> void:
	var new_quest_requirement_dictionary = {}
	
	for req in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"]:
		if req == currently_editing_quest_requirement:
			new_quest_requirement_dictionary[new_quest_requirement_text] = EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][currently_editing_quest_requirement]
		else:
			new_quest_requirement_dictionary[req] = EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][currently_editing_quest_requirement]
	
	EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"].clear()
	EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"] = new_quest_requirement_dictionary.duplicate(true)
	EventManager.save_quest_library()
	_on_quest_tracker_viewer_button_pressed(currently_editing_quest_requirement_idx)


func _on_add_requirement_pressed() -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_new_req_text.text] = []
	EventManager.save_quest_library()
	
	quest_tracker_viewer_option.clear()
	quest_tracker_req_events_option.clear()
	quest_tracker_remove_events_option.clear()
	
	for req in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"]:
		quest_tracker_viewer_option.add_item(req)
	
	quest_tracker_viewer_option.select(quest_tracker_viewer_option.get_selectable_item(true))
	
	quest_tracker_edit_req_text.text = quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)
	quest_tracker_new_req_text.text = ""
	quest_tracker_req_events_text.text = ""
	
	for req_event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_req_events_text.append_text(req_event + "\n")
	
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
			if flag.find("_Done") < 0:
				quest_tracker_req_events_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text:
				quest_tracker_req_events_option.add_item(flag)
	
	for event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_remove_events_option.add_item(event)


func _on_requirement_list_item_selected(index: int) -> void:
	quest_tracker_req_events_option.clear()
	quest_tracker_remove_events_option.clear()
	quest_tracker_viewer_option.selected = index
	
	quest_tracker_edit_req_text.text = quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)
	quest_tracker_new_req_text.text = ""
	quest_tracker_req_events_text.text = ""
	
	for req_event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_req_events_text.append_text(req_event + "\n")
	
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
			if flag.find("_Done") < 0:
				quest_tracker_req_events_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text:
				quest_tracker_req_events_option.add_item(flag)
	
	for event in EventManager.quest_library[quest_parameters.get_child(0).get_child(currently_editing_quest_requirement_idx).text]["QuestCompletionTracker"][quest_tracker_viewer_option.get_item_text(quest_tracker_viewer_option.selected)]:
		quest_tracker_remove_events_option.add_item(event)


#---------------------------------------------------------------------------
#     Quest Completion Flags Functions
#---------------------------------------------------------------------------

func _on_view_quest_completion_pressed(index : int) -> void:
	quest_completion_flags_text.clear()
	
	if quest_completion_add_existing_flags_button.pressed.is_connected(_on_add_existing_completion_flags_pressed):
		quest_completion_add_existing_flags_button.pressed.disconnect(_on_add_existing_completion_flags_pressed)
	if quest_completion_add_custom_flags_button.pressed.is_connected(_on_add_custom_completion_flags_pressed):
		quest_completion_add_custom_flags_button.pressed.disconnect(_on_add_custom_completion_flags_pressed)
	if quest_completion_remove_flags_button.pressed.is_connected(_on_remove_completion_flags_pressed):
		quest_completion_remove_flags_button.pressed.disconnect(_on_remove_completion_flags_pressed)
	
	quest_completion_add_existing_flags_button.pressed.connect(_on_add_existing_completion_flags_pressed.bind(index))
	quest_completion_add_custom_flags_button.pressed.connect(_on_add_custom_completion_flags_pressed.bind(index))
	quest_completion_remove_flags_button.pressed.connect(_on_remove_completion_flags_pressed.bind(index))
	
	quest_completion_name.text = "Quest: " + quest_parameters.get_child(0).get_child(index).text
	
	for flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"]:
		quest_completion_flags_text.append_text(flag + "\n")
	
	quest_completion_add_existing_flags_option.clear()
	for flag in EventManager.all_possible_flags:
		if not flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"]:
			if flag.find("_Done") < 0:
				quest_completion_add_existing_flags_option.add_item(flag)
			elif not flag.erase(flag.find("_Done"), 5) in EventManager.quest_library and not flag.erase(flag.find("_Done"), 5) in EventManager.event_library:
				quest_completion_add_existing_flags_option.add_item(flag)
	
	quest_completion_add_custom_flags_line.clear()
	
	quest_completion_remove_flags_option.clear()
	for flag in EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"]:
		if flag.find("_Done") < 0:
			quest_completion_remove_flags_option.add_item(flag)
		elif not flag.erase(flag.find("_Done"), 5) == quest_parameters.get_child(0).get_child(index).text:
			quest_completion_remove_flags_option.add_item(flag)
	
	quest_completion_viewer_db.visible = true


func _on_add_existing_completion_flags_pressed(index : int) -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"].append(quest_completion_add_existing_flags_option.get_item_text(quest_completion_add_existing_flags_option.selected))
	_on_view_quest_completion_pressed(index)
	EventManager.save_quest_library()

func _on_add_custom_completion_flags_pressed(index : int) -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"].append(quest_completion_add_custom_flags_line.text)
	EventManager.update_all_flags()
	_on_view_quest_completion_pressed(index)
	EventManager.save_quest_library()


func _on_remove_completion_flags_pressed(index : int) -> void:
	EventManager.quest_library[quest_parameters.get_child(0).get_child(index).text]["QuestCompletionFlags"].erase(quest_completion_remove_flags_option.get_item_text(quest_completion_remove_flags_option.selected))
	_on_view_quest_completion_pressed(index)
	EventManager.save_quest_library()


#---------------------------------------------------------------------------
#     Quest Edit Name Functions
#---------------------------------------------------------------------------

func _on_quest_name_edit_focus_entered(quest_name : String, index : int) -> void:
	new_event_name = quest_name
	currently_editing_event_name = quest_name
	currently_editing_event_index = index
	


func _on_quest_name_edit_focus_exited() -> void:
	var new_quest_dictionary : Dictionary = {}
	
	for quest in EventManager.quest_library:
		if quest == currently_editing_event_name:
			new_quest_dictionary[new_event_name] = EventManager.quest_library[quest]
		else:
			new_quest_dictionary[quest] = EventManager.quest_library[quest]
	
	for quest in new_quest_dictionary:
		for flag in new_quest_dictionary[quest]["QuestCompletionFlags"]:
			if flag.find("_Done") < 0:
				pass
			elif currently_editing_event_name == flag.erase(flag.find("_Done"), 5):
				new_quest_dictionary[quest]["QuestCompletionFlags"][new_quest_dictionary[quest]["QuestCompletionFlags"].find(flag)] = new_event_name + "_Done"
	
	for event in EventManager.event_library:
		for prereq in EventManager.event_library[event]["EventPrerequisiteFlags"]:
			if prereq.find("_Done") < 0:
				pass
			elif currently_editing_event_name == prereq.erase(prereq.find("_Done"), 5):
				EventManager.event_library[event]["EventPrerequisiteFlags"][EventManager.event_library[event]["EventPrerequisiteFlags"].find(prereq)] = new_event_name + "_Done"
		for flag in EventManager.event_library[event]["EventCompletionFlags"]:
			if flag.find("_Done") < 0:
				pass
			elif currently_editing_event_name == flag.erase(flag.find("_Done"), 5):
				EventManager.event_library[event]["EventCompletionFlags"][EventManager.event_library[event]["EventCompletionFlags"].find(flag)] = new_event_name + "_Done"
	
	
	EventManager.quest_library.clear()
	EventManager.quest_library = new_quest_dictionary.duplicate(true)
	EventManager.update_all_flags()
	call_deferred("refresh_quests")
	call_deferred("refresh_events")
	EventManager.save_quest_library()
	EventManager.save_event_library()


func _on_quest_name_text_changed(new_text : String) -> void:
	new_event_name = new_text
