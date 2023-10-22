extends Node


@onready var ground = $Ground

var focus = load("res://focus/Focus.tscn")

var GalaxyClass = load("res://galaxy/GalaxyClass.gd")

var PlanetClass = load("res://planets/PlanetClass.gd")
var planet_scene = load("res://planets/Planet.tscn")


func _ready():
	var galaxy = GalaxyClass.new("Fred", "Grid", 100, 4)
	
	var planet_names = galaxy.load_planet_names(galaxy._size)
	var planet_skins = galaxy.load_planet_skins(galaxy._size)
	var planet_coords = []
	if galaxy._shape == "Grid":
		planet_coords = galaxy.grid(galaxy._size, galaxy._density)
	
	for i in range(galaxy._size):
		var planet_instance = planet_scene.instantiate()
		var mesh_instance = planet_instance.get_node("MeshInstance3D")
		
		# Get the id of the newly instantiated RigidBody3D
		# This will be used as a UID of the planet for the rest of the game
		var rigidbody3d = "<RigidBody3D#" + str(planet_instance.get_instance_id()) + ">"

		var planet = PlanetClass.new(planet_names[i], rigidbody3d, planet_skins[i], planet_coords[i], \
			"", "", "", "", "", "")
		PlanetGlobal.planets.append(planet)
		
		var skin = planet_skins[i]
		var material = StandardMaterial3D.new()
		material.albedo_texture = skin
		mesh_instance.material_override = material
	
		add_child(planet_instance)
		planet_instance.transform.origin = planet_coords[i]
