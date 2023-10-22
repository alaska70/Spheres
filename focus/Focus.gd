extends CharacterBody3D

@export var speed = 14
@export var fall_accel = 75

var focus_velocity = Vector3.ZERO
var bump_timer = 0.0
var snap_distance = 0.5
var snap_duration = 0.5
var is_snapping = false

@onready var focus = $"."

@onready var shape_cast = $ShapeCast3D

@onready var mesh_instance = $MeshInstance3D

@onready var snap_timer = $SnapTimer

var green_focus = preload("res://assets/focus/focus_green.png")
var yellow_focus = preload("res://assets/focus/focus_yellow.png")
var red_focus = preload("res://assets/focus/focus_red.png")


func _process(delta):
	rotate_focus(delta)


func _physics_process(delta):
	move_focus()
	fall_to_floor(delta)
	bumped_planet()
	check_planet_collision()
	

func move_focus():
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		
	focus_velocity.x = direction.x * speed
	focus_velocity.z = direction.z * speed
	
	velocity = focus_velocity
	move_and_slide()


func fall_to_floor(delta):
	if not is_on_floor():
		focus_velocity.y = focus_velocity.y - (fall_accel * delta)

func bumped_planet():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider != null:
			if collision.get_collider().is_in_group("planet"):
				var planet = collision.get_collider()
				planet._on_focus_bumped()
				PlanetGlobal.planet_bumped = planet
				snap_timer.start()
		else:
			snap_timer.stop()


func check_planet_collision():
	var material = StandardMaterial3D.new()
	# Perform the shape cast
	if shape_cast.is_colliding():
		# A collision was detected
		var collider = shape_cast.get_collider(0)
		if collider is RigidBody3D:
			material.albedo_texture = green_focus
			mesh_instance.material_override = material
	else:
		material.albedo_texture = yellow_focus
		mesh_instance.material_override = material


func rotate_focus(delta):
	focus.rotate(Vector3(0, 1, 0), delta)


func _on_snap_timer_timeout():
	# Snap the focus directly underneath the collided planet
	var snapped = false

	var planet = PlanetGlobal.planet_bumped
	position = Vector3(planet.position.x, .25, planet.position.z)
	snapped = true

	if snapped:
		snap_timer.stop()  # Stop the timer after successful snapping
		
	set_active_planet()


func set_active_planet():
	var planet_bumped = PlanetGlobal.planet_bumped
	for planet in PlanetGlobal.planets:
		if planet._rigidbody3d in str(planet_bumped):
			PlanetGlobal.active_planet = planet
			print(PlanetGlobal.active_planet._name)
