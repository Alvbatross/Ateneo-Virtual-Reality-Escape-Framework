@tool
class_name EventManagerUI
extends Control

@export var dictionary : Dictionary

@onready var add_parameter_db := $AddParameterDB
@onready var add_parameter_name := $AddParameterDB/VBoxContainer/LineEdit
@onready var add_parameter_type := $AddParameterDB/VBoxContainer/OptionButton

@onready var add_event_db := $AddEventDB
@onready var add_event_name := $AddEventDB/VBoxContainer/LineEdit

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

@onready var parameters := $TabContainer/EventEditor/VBoxContainer/ScrollContainer/VBoxContainer/Parameters

var currently_editing_event_name : String = ""
var currently_editing_event_index : int = 0
var new_event_name : String = ""

var currently_removing_category : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parameters.add_spacer(false)
	refresh_event_parameters()
	refresh_events()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parameters.get_child_count() == 0:
		refresh_event_parameters()
		refresh_events()


func refresh_event_parameters() -> void:
	for child in parameters.get_children():
		print(child)
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
				line_edit.custom_minimum_size.y = 30
			elif param.get_child(0).text == "EventCategory":
				var option_button = OptionButton.new()
				for cat in EventManager.event_manager_settings["Categories"]:
					option_button.add_item(cat)
				option_button.select(EventManager.event_manager_settings["Categories"].find(EventManager.event_library[e]["EventCategory"]))
				param.add_child(option_button)
				option_button.item_selected.connect(_on_event_category_item_selected.bind(option_button.get_index(), option_button))
				option_button.custom_minimum_size.y = 30
			else:
				if typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_STRING or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_FLOAT or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_INT:
					var line_edit = LineEdit.new()
					line_edit.text = str(EventManager.event_library[e][param.get_child(0).text])
					param.add_child(line_edit)
					line_edit.custom_minimum_size.y = 30
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_BOOL:
					var check_box = CheckBox.new()
					check_box.button_pressed = EventManager.event_library[e][param.get_child(0).text]
					param.add_child(check_box)
					check_box.toggled.connect(_on_event_checkbox_toggled.bind(param.get_child(0).text, check_box.get_index()))
					check_box.custom_minimum_size.y = 30
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_DICTIONARY:
					var view_button = Button.new()
					view_button.text = "View " + param.get_child(0).text
					param.add_child(view_button)
					view_button.pressed.connect(_on_custom_array_dictionary_param_pressed.bind(param.get_child(0).text, "Dictionary", view_button.get_index()))
					view_button.custom_minimum_size.y = 30
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
					view_button.custom_minimum_size.y = 30


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
		"Category":
			EventManager.event_manager_settings["Categories"].erase(remove_option.get_item_text(remove_option.selected))
		"Parameter":
			EventManager.event_manager_settings["Parameters"].erase(remove_option.get_item_text(remove_option.selected))
			for event in EventManager.event_library:
				EventManager.event_library[event].erase(remove_option.get_item_text(remove_option.selected))
	
	print(EventManager.event_manager_settings)
	print(EventManager.event_library)
	EventManager.save_event_library()
	EventManager.save_event_settings()
	refresh_event_parameters()
	refresh_events()


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
	print(EventManager.all_possible_flags)
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
			elif not flag.erase(flag.find("_Done"), 5) in EventManager.event_library:
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
	print(EventManager.all_possible_flags)
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
	print(currently_editing_event_name)
	print(currently_editing_event_index)


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
	print(EventManager.event_library)
	call_deferred("refresh_events")
	EventManager.save_event_library()

#---------------------------------------------------------------------------
#     EDIT CHECKBOX PARAMETER FUNCTION
#---------------------------------------------------------------------------

func _on_event_checkbox_toggled(toggled : bool, parameter : String, index : int) -> void:
	EventManager.event_library[parameters.get_child(0).get_child(index).text][parameter] = toggled
	print(EventManager.event_library)
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
