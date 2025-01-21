@tool
class_name OISColliderArea3D
extends OISCollider

var area_3d : Area3D
var collision_shape_3d : CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	if not has_node("Area3D"):
		area_3d = Area3D.new()
		collision_shape_3d = CollisionShape3D.new()
		area_3d.name = "Area3D"
		collision_shape_3d.name = "CollisionShape3D"
		add_child(area_3d)
		area_3d.add_child(collision_shape_3d)
		area_3d.owner = get_tree().edited_scene_root
		collision_shape_3d.owner = get_tree().edited_scene_root


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	
	if get_node("Area3D/CollisionShape3D").shape == null:
		warnings.append("This Node's CollisionShape3D requires a Shape")

	# Return warnings
	return warnings
