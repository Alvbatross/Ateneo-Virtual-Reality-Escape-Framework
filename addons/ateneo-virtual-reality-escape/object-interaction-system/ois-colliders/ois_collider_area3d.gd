@tool
class_name OISColliderArea3D
extends OISCollider


var area_3d := Area3D.new()
var collision_shape_3d := CollisionShape3D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	if Engine.is_editor_hint() and not has_node("Area3D"):
		area_3d.name = "Area3D"
		collision_shape_3d.name = "CollisionShape3D"
		area_3d.collision_layer = ois_collision_layer
		area_3d.collision_mask = ois_collision_layer
		add_child(area_3d)
		area_3d.add_child(collision_shape_3d)
		area_3d.owner = get_tree().edited_scene_root
		collision_shape_3d.owner = get_tree().edited_scene_root
	
	if not Engine.is_editor_hint():
		area_3d = get_node("Area3D")
		collision_shape_3d = get_node("Area3D/CollisionShape3D")
		area_3d.collision_layer = ois_collision_layer
		area_3d.collision_mask = ois_collision_layer
		area_3d.area_entered.connect(_emit_body_entered)
		area_3d.area_exited.connect(_emit_body_exited)
		
		


func collider_enabled(b: bool) -> void:
	area_3d.set_deferred("monitoring", b) 
	area_3d.set_deferred("monitorable", b)
	collision_shape_3d.set_deferred("disabled", !b)



func _emit_body_entered(body) -> void:
	body_entered.emit(body)


func _emit_body_exited(body) -> void:
	body_exited.emit(body)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This Node's CollisionShape3D requires a Shape")

	# Return warnings
	return warnings
