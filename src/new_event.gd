extends Event

func _on_event_started() -> void:
	pass


func _on_ois_crank_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	close_event()
