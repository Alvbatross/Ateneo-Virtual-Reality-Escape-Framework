@tool
extends ConfirmationDialog


@export var event_group_resource : Resource
@onready var event_parameter_list := $VBoxContainer/ScrollContainer/MarginContainer/EventParameterList
@onready var add_parameter_db := $AddParameterDB
@onready var add_parameter_name := $AddParameterDB/VBoxContainer/LineEdit
@onready var add_parameter_type := $AddParameterDB/VBoxContainer/OptionButton

func _ready() -> void:
	reset_parameter_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset_parameter_list() -> void:
	event_parameter_list.text = ""
	print(event_group_resource.parameters)
	for p in event_group_resource.parameters:
		event_parameter_list.add_text(p + "\n")


func _on_line_edit_text_changed(new_text: String) -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	add_parameter_db.visible = true


func _on_add_parameter_db_confirmed() -> void:
	match add_parameter_type.selected:
		0:
			event_group_resource.parameters[add_parameter_name.text] = 0
		1:
			event_group_resource.parameters[add_parameter_name.text] = 0.0
		2:
			event_group_resource.parameters[add_parameter_name.text] = ""
		3:
			event_group_resource.parameters[add_parameter_name.text] = []
		4:
			event_group_resource.parameters[add_parameter_name.text] = {}
		5:
			event_group_resource.parameters[add_parameter_name.text] = false
	
	reset_parameter_list()
