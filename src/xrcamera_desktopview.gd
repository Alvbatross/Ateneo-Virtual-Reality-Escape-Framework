extends Camera3D

@export var xr_origin : XROrigin3D
@export var xr_camera : XRCamera3D

func _physics_process(delta: float) -> void:
	self.global_transform = XRServer.get_hmd_transform()
	self.position = xr_origin.position + xr_camera.position
