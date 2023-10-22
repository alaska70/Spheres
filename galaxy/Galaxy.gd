extends Node

var GalaxyClass = load("res://galaxy/GalaxyClass.gd")

var planet_scene = load("res://planets/Planet.tscn")

func _ready():
	create_planets()


func create_planets():
	var count = 100
	var galaxy = GalaxyClass.new("", "", "", "", "", "", "", "", "")
	var coords = galaxy.arrange_planets_grid(10, 10)
	var skins = galaxy.load_planet_skins(count)
	var names = galaxy.load_planet_names(count)
	
	for i in range(count):
		var planet_instance = planet_scene.instantiate()
		var mesh_instance = planet_instance.get_node("MeshInstance3D")

		var skin = skins[i]
		var material = StandardMaterial3D.new()
		material.albedo_texture = skin
		mesh_instance.material_override = material
	
		add_child(planet_instance)
		planet_instance.transform.origin = coords[i]

func arrange_planets_grid(wide, high):
	var coords = []
	for i in range(wide):
		for j in range(high):
			var x = i * 2
			var z = j * 2
			coords.append(Vector3(x, 0, z))

	return(coords)


func load_planet_skins(count):
	var skins = []
	var planet_path = "res://assets/skins/"
	var dir = DirAccess.open(planet_path)
	dir.list_dir_begin()
	var i = 0
	while i < count:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			skins.append(load(planet_path + "/" + file_name))
			i += 1
	dir.list_dir_end()
	print(skins)
	return(skins)


func load_planet_names(count):
	var all_names = []
	var names = []
	var path = "res://assets/names/PlanetNames.txt"
	var names_file = FileAccess.open(path, FileAccess.READ)
	while !names_file.eof_reached():
		var csv = names_file.get_csv_line()
		var text = str(csv)
		text = text.trim_prefix('["')
		text = text.trim_suffix('"]')
		all_names.append(text)
	all_names.pop_front()
	
	for i in range(count):
		var index = randi() % all_names.size()
		var element = all_names[index]
		names.append(element)
		all_names.remove(index)
	
	return names
