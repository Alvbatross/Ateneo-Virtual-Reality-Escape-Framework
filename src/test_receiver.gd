extends Node3D

@onready var progress_view := $"Progress View"

func _on_ois_wipe_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	print(total_progress)
	print(requirement)
	var percentage = total_progress/requirement
	print(percentage)
	print(str(percentage) +"%")
	progress_view.visible = true
	progress_view.change_progress_value(percentage*100)
