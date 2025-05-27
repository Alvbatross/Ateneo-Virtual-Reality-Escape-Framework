extends CanvasLayer

@export var texture_rect : TextureRect

var xr_view_visible : bool

func _ready():
	xr_view_visible = false
	
func _toggle_xr_view():
	xr_view_visible = !xr_view_visible
	texture_rect.visible = xr_view_visible
