extends Node


var _name
var _shape
var _size
var _density


func _init(galaxy_name, galaxy_shape, galaxy_size, galaxy_density):
	self._name = galaxy_name
	self._shape = galaxy_shape
	self._size = galaxy_size
	self._density = galaxy_density


func grid(size, density):
	var coords = []
	var dimension = sqrt(size)
	for i in range(dimension):
		for j in range(dimension):
			coords.append(Vector3(i * density, 5, j * density))
	return(coords)


func load_planet_skins(size):
	var skins = []
	var planet_path = "res://assets/skins/"
	var dir = DirAccess.open(planet_path)
	dir.list_dir_begin()
	var i = 0
	while i < size:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			skins.append(load(planet_path + "/" + file_name))
			i += 1
	dir.list_dir_end()
	return(skins)


func load_planet_names(size):
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
	
	for i in range(size):
		var index = randi() % all_names.size()
		var element = all_names[index]
		names.append(element)
		all_names.erase(index)	
	return names
