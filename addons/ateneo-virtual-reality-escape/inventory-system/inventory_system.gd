@tool
class_name InventorySystem
extends Node3D

@export_category("Editor Settings")
@export var reinitialize_inventory: bool

@export_category("Inventory Settings")
@export_range(1,5) var row_count : int = 3
@export_range(1,5) var column_count : int = 2

@export_category("Spacing Options")
@export_range(0,2) var row_spacing : float = 0.3
@export_range(0,2) var column_spacing : float = 0.3

@export_category("Slot Options")
@export var update_slot_radius: bool
@export_range(0,2) var slot_size : float = 0.1

@export_category("Player Options")
@export var follow_player_camera : bool
@export var xr_anchor_to_object: XROrigin3D
@export var xr_camera_anchor: XRCamera3D
@export var inventory_toggler_hand : XRController3D
@export var inventory_toggler_button : String
@export var audio_node : AudioStreamPlayer3D

@export var local_transform_adjustment : Vector3
@export var slots_distance_to_player : float = 0.75
@export var height_adjustment : float = 1.4
@export var camera_window_width : float = 1.0

@export_category("Debug")
@export var inventory_dictionary : Dictionary

var inventory_toggled : bool

var space_count_row = 0
var space_count_column = 0

var position_offset : Vector3

var prev_camera_rotation : float
var current_camera_rotation : float

# Place all common Inventory System Stuff in here. Common to shelf type and Wrist type inventories. 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_child_count() == 0:
		initialize_inv()
	
	if not Engine.is_editor_hint():
	# Make sure signals are connected.
		for inventory_slot in get_children():
			inventory_slot.current_object_in_slot.connect(update_slot_item)
			inventory_slot.position += local_transform_adjustment
			print("[AVRE - Inventory] Slot "+inventory_slot.name+" initiated.")
			# Ensure the slots in runtime are the ones inside the inventory dictionary EVERY TIME.
			inventory_dictionary[int(inventory_slot.name.split("_")[1])][int(inventory_slot.name.split("_")[2])][0] = inventory_slot
	
	inventory_toggler_hand.button_pressed.connect(_toggle_inventory)
	inventory_toggled = self.visible

func _toggle_inventory(button) -> void:
	if button == inventory_toggler_button:
		inventory_toggled = !inventory_toggled
		center_inventory()
		self.visible = inventory_toggled
		
		if is_instance_valid(audio_node):
			audio_node.playing = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint() and reinitialize_inventory:
		initialize_inv()
		reinitialize_inventory = false
	
	if Engine.is_editor_hint():
		_update_inventory_system()
	

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint() and follow_player_camera:
		reposition_inventory(delta)

func initialize_inv() -> void:
	print("[AVRE - Inventory] Initializing inventory...")
	
	clear_all_children()
	inventory_dictionary.clear()
	space_count_row = row_count
	space_count_column = column_count
	
	self.position = local_transform_adjustment
		
	for x in range(space_count_row):
		var row_array = []
		for y in range(space_count_column):
			var inventory_slot := InventorySlot.new()
			
			inventory_slot.name = "Slot_"+str(x)+"_"+str(y)
			inventory_slot.position = Vector3(column_spacing * y, x * row_spacing, 0) + local_transform_adjustment
			inventory_slot.snap_zone_radius = slot_size
			inventory_slot.update_slot_settings = true
			
			add_child(inventory_slot,true)
			if y < column_count and x < row_count:
				inventory_slot.owner = get_tree().edited_scene_root
			
			
			var content = null
			var file_path = null
			
			if is_instance_valid(inventory_slot.default_object):
				content = inventory_slot.default_object
				if is_instance_valid(inventory_slot.default_object.get_scene_file_path()):
					file_path = inventory_slot.default_object.get_scene_file_path()
			
			row_array.append([inventory_slot,content,file_path])

		inventory_dictionary[x] = row_array


func _update_inventory_system() -> void:
	if Engine.is_editor_hint() and has_node("Slot_0_0"):
		for row_slots in inventory_dictionary.keys():
			for column_slots in range(inventory_dictionary[row_slots].size()):
				if is_instance_valid(inventory_dictionary[row_slots][column_slots][0]):
					inventory_dictionary[row_slots][column_slots][0].position = Vector3(column_spacing * column_slots, int(row_slots) * row_spacing, 0) + local_transform_adjustment
		if update_slot_radius:
			for slot in get_children():
				slot.snap_zone_radius = slot_size
				slot.update_slot_settings = true
			update_slot_radius = false
					
				
func clear_all_children() -> void:
	if get_child_count() > 0:
		for child in get_children():
			self.remove_child(child)
			child.queue_free()

func update_slot_item(what, row, col) -> void:
	inventory_dictionary[row][col][1] = what
	if inventory_dictionary[row][col][1] != null:
		inventory_dictionary[row][col][2] = inventory_dictionary[row][col][1].get_scene_file_path()
		print("[AVRE - Inventory] "+inventory_dictionary[row][col][1].name+" path: "+inventory_dictionary[row][col][1].get_scene_file_path())
	else:
		print("[AVRE - Inventory] No object in slot row "+str(row)+" column "+str(col)+".")


func center_inventory() -> void:
	position_offset
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		current_camera_rotation = xr_camera_anchor.global_rotation.y
			
		var position_x_rotate = slots_distance_to_player * cos(current_camera_rotation - self.get_parent().global_rotation.y)
		var position_z_rotate = slots_distance_to_player * sin(current_camera_rotation - self.get_parent().global_rotation.y)
		self.rotation.y = current_camera_rotation - self.get_parent().global_rotation.y
		
		position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
		self.global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset


func reposition_inventory(delta : float) -> void:
	position_offset
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		if abs(xr_camera_anchor.global_rotation.y - self.global_rotation.y) > camera_window_width:
			current_camera_rotation = xr_camera_anchor.global_rotation.y
			
			var delta_camera_rotation = current_camera_rotation - prev_camera_rotation
			
			var adjustment_value = current_camera_rotation
			#print("-----------------------------------------")
			#print("DELTA CAMERA ROTATION: " + str(delta_camera_rotation))
			#print("CURRENT CAMERA ROTATION: " + str(current_camera_rotation))
			if (delta_camera_rotation > PI || delta_camera_rotation < -PI):
				delta_camera_rotation = sign(delta_camera_rotation)*(abs(delta_camera_rotation)-(TAU))
				#adjustment_value = sign(current_camera_rotation)*(abs(current_camera_rotation)-(2*PI))
				#print("CHANGED DELTA CAMERA ROTATION: " + str(delta_camera_rotation))
				#print("CHANGED CURRENT CAMERA ROTATION: " + str(adjustment_value))
			#print("-----------------------------------------")
			#xxr_camera_anchor.global_rotation.y = current_camera_rotation
			
			
			
			if delta_camera_rotation > 0:
				adjustment_value -= camera_window_width
			else:
				adjustment_value += camera_window_width
				
			var position_x_rotate = slots_distance_to_player * cos(adjustment_value - self.get_parent().global_rotation.y)
			var position_z_rotate = slots_distance_to_player * sin(adjustment_value - self.get_parent().global_rotation.y)
			self.rotation.y = adjustment_value - self.get_parent().global_rotation.y
			#print("CAMERA ROTATION: " + str(rad_to_deg(xr_camera_anchor.global_rotation.y)))
			#print("INVENTORY ROTATION: " + str(self.global_rotation.y))
			
			position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
			self.global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset
			
			prev_camera_rotation = current_camera_rotation
	
		if is_instance_valid(audio_node):
			audio_node.global_position = self.global_position


func export_save_data() -> Dictionary:
	print("[AVRE - Inventory] Saving data..")
	return inventory_dictionary

func import_save_data(data : Dictionary) -> void:
	print("[AVRE - Inventory] Loading save data..")
	for row_slots in inventory_dictionary.keys():
			for column_slots in range(inventory_dictionary[row_slots].size()):
				
				if data[row_slots][column_slots][2] != null:
					inventory_dictionary[row_slots][column_slots][2] = data[row_slots][column_slots][2]
					var loaded_item = load(inventory_dictionary[row_slots][column_slots][2]).instantiate()
					
					# Making sure if the object has the InventoryItem script.
					if is_instance_valid(loaded_item.get_node("InventoryItem")):
						# If the item is supposed to be unique, find it inside the scene.
						if loaded_item.get_node("InventoryItem").unique:
							var loaded_item_name = loaded_item.name
							if is_instance_valid(get_parent().find_child(loaded_item_name)):
								inventory_dictionary[row_slots][column_slots][0]._pick_up_object(get_parent().find_child(loaded_item_name))
								inventory_dictionary[row_slots][column_slots][1] = inventory_dictionary[row_slots][column_slots][0].current_object
							else:
								get_parent().add_child(loaded_item)
								inventory_dictionary[row_slots][column_slots][0]._pick_up_object(loaded_item)
								inventory_dictionary[row_slots][column_slots][1] = inventory_dictionary[row_slots][column_slots][0].current_object
						else:
							get_parent().add_child(loaded_item)
							inventory_dictionary[row_slots][column_slots][0]._pick_up_object(loaded_item)
							inventory_dictionary[row_slots][column_slots][1] = inventory_dictionary[row_slots][column_slots][0].current_object
					# If it doesn't have it, just put the item as is.
					else:
						get_parent().add_child(loaded_item)
						inventory_dictionary[row_slots][column_slots][0]._pick_up_object(loaded_item)
						inventory_dictionary[row_slots][column_slots][1] = inventory_dictionary[row_slots][column_slots][0].current_object
	
	
