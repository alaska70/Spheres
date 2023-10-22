extends Camera3D

@onready var focus = $"../../Focus"
@onready var camera_pivot = $".."
@onready var camera_3d = $"."

var rotation_speed = 60


func _process(delta):
	track_focus_with_camera(delta)
	rotate_around_focus_character(delta)
	

func rotate_around_focus_character(delta):
	# Rotate the camera around the focus character
	var theta = deg_to_rad(rotation_speed * delta)
	#var rotation_center = focus.global_transform.origin #+ Vector3(0, 10, 0)
	
	if Input.is_action_pressed("rotate_left"):
		global_transform.origin = camera_3d.global_transform.origin
		global_transform.basis = camera_3d.global_transform.basis.rotated(Vector3(0, 1, 0), theta)
		
	if Input.is_action_pressed("rotate_right"):
		global_transform.origin = camera_3d.global_transform.origin
		global_transform.basis = camera_3d.global_transform.basis.rotated(Vector3(0, 1, 0), -theta)
	
	
func track_focus_with_camera(delta):
	if focus:
		var camera_3d_pos = camera_3d.global_transform.origin
		print("camera_3d_pos = " + str(camera_3d_pos))
		camera_3d.global_transform.origin = focus.global_transform.origin.lerp(camera_3d.position, 0.1) + Vector3(0, 10, 10)
