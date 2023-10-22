extends RigidBody3D

signal focus_bumped

@export var bump_up = 1

var planet_velocity = Vector3.ZERO

#var bumps = 0

func _on_visible_on_screen_notifier_3d_screen_exited():
	#self.visible = false
	var x = 0


func _on_visible_on_screen_notifier_3d_screen_entered():
	# self.visible = true
	var x = 0


func _on_focus_bumped():
	planet_velocity.y = bump_up
	var bump = Vector3(0, bump_up, 0)
	apply_impulse(bump, Vector3.ZERO)
