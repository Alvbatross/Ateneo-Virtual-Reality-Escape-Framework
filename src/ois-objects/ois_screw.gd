extends StaticBody3D


@onready var progress_view := $"Progress View" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ois_twist_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	print(total_progress)
	print(requirement)
	var percentage = total_progress/requirement
	print(percentage)
	print(str(percentage) +"%")
	progress_view.visible = true
	progress_view.change_progress_value(percentage*100)
