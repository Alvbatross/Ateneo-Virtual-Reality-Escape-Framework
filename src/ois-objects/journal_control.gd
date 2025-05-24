extends Node

@onready var journal_cover := $"../quest_log2 (added shapekeys)/Book cover"
@onready var journal_pages := $"../quest_log2 (added shapekeys)/Pages"
@onready var journal_content := $"../Viewport2Din3D"
@onready var journal_hitbox := $"../CollisionShape3D"
@onready var light := $"../OmniLight3D"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@onready var journal_ui := $"../Viewport2Din3D/Viewport/JournalUI"

@onready var handle_left := $"../PageTurnerLeft/InteractableHandle"
@onready var handle_right := $"../PageTurnerRight/InteractableHandle"

@onready var journal_slot := get_tree().get_root().get_node("Main/InventorySystem/Slot_1_0")
@onready var inventory_item := $"../InventoryItem"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_journal()
	handle_left.enabled = false
	handle_right.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not handle_left.is_picked_up():
		handle_left.global_transform = handle_left.handle_origin.global_transform
	
	if not handle_right.is_picked_up():
		handle_right.global_transform = handle_right.handle_origin.global_transform

func open_journal() -> void:
	animation_player.play("book_opening")
	await animation_player.animation_finished
	
	light.light_energy = 0.1
	journal_content.visible = true


func close_journal() -> void:
	journal_content.visible = false
	light.light_energy = 0
	animation_player.play("book_closing")
	await animation_player.animation_finished
	


func _on_ois_journal_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		open_journal()
		inventory_item.call_deferred("_force_enlarge_item")
		inventory_item.is_grabbed = true
		
		handle_left.enabled = true
		handle_right.enabled = true


func _on_ois_journal_released(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		close_journal()
	
	journal_slot._pick_up_object_init(get_parent())
	inventory_item.is_grabbed = false
	inventory_item.call_deferred("_force_shrink_item")
	
	handle_left.enabled = false
	handle_right.enabled = false


func _on_page_turn_left_action_completed(requirement: Variant, total_progress: Variant) -> void:
	if animation_player.is_playing():
		return
	animation_player.play("flip_page_left")
	journal_ui.page_turn_left()
	await animation_player.animation_finished
	animation_player.play("RESET")
	


func _on_page_turn_right_action_completed(requirement: Variant, total_progress: Variant) -> void:
	if animation_player.is_playing():
		return
	animation_player.play("flip_page_right")
	journal_ui.page_turn_right()
	await animation_player.animation_finished
	animation_player.play("RESET")
