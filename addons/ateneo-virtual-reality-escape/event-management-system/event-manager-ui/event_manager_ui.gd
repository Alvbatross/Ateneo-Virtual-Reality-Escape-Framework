@tool
class_name EventManagerUI
extends Control


@onready var event_editor_view_button := $VBoxContainer/HBoxContainer/EventEditor
@onready var quest_editor_view_button := $VBoxContainer/HBoxContainer/QuestEditor

@onready var add_parameter_db := $AddParameterDB
@onready var add_parameter_name := $AddParameterDB/VBoxContainer/LineEdit
@onready var add_parameter_type := $AddParameterDB/VBoxContainer/OptionButton

@onready var add_event_db := $AddEventDB
@onready var add_event_name := $AddEventDB/VBoxContainer/LineEdit

@onready var parameters := $VBoxContainer/EventEditor/VBoxContainer/ScrollContainer/VBoxContainer/Parameters

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parameters.add_spacer(false)
	refresh_event_parameters()
	refresh_events()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if parameters.get_child_count() == 0:
		refresh_event_parameters()

func refresh_event_parameters() -> void:
	for child in parameters.get_children():
		print(child)
		child.free()
	var i = 0
	for p in EventManager.event_manager_params:
		var vbox = VBoxContainer.new()
		vbox.ALIGNMENT_CENTER
		parameters.add_child(vbox)
		var label = Label.new()
		label.text = p
		parameters.get_child(i).add_child(label)
		i += 1


func refresh_events() -> void:
	for child in parameters.get_children():
		for c in child.get_children():
			if !c.get_index() == 0:
				c.queue_free()
	for e in EventManager.event_library:
		for param in parameters.get_children():
			if param.get_child(0).text == "EventName":
				var line_edit = LineEdit.new()
				line_edit.text = e
				param.add_child(line_edit)
			elif param.get_child(0).text == "EventCategory":
				var option_button = OptionButton.new()
				for cat in EventManager.event_categories:
					option_button.add_item(cat)
				param.add_child(option_button)
			else:
				if typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_STRING or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_FLOAT or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_INT or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_ARRAY or typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_DICTIONARY:
					var line_edit = LineEdit.new()
					line_edit.text = str(EventManager.event_library[e][param.get_child(0).text])
					param.add_child(line_edit)
				elif typeof(EventManager.event_library[e][param.get_child(0).text]) == TYPE_BOOL:
					var check_box = CheckBox.new()
					check_box.button_pressed = EventManager.event_library[e][param.get_child(0).text]
					param.add_child(check_box)
	
	

func _on_event_editor_toggled(toggled_on: bool) -> void:
	pass


func _on_quest_editor_toggled(toggled_on: bool) -> void:
	pass


func _on_add_event_pressed() -> void:
	add_event_name.text = ""
	add_event_db.visible = true


func _on_add_event_parameter_pressed() -> void:
	add_parameter_name.text = ""
	add_parameter_type.selected = -1
	add_parameter_db.visible = true


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
	
	refresh_event_parameters()
	refresh_events()


func _on_add_event_db_confirmed() -> void:
	EventManager.add_new_event(add_event_name.text)
	refresh_events()
