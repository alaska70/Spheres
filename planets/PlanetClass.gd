extends Node3D

var _name
var _rigidbody3d
var _texture
var _coord
var _resources
var _radius
var _temp
var _owned_by
var _population
var _ip

var coords = []

func _init(planet_name, rigidbody3d, texture, coord, resources, radius, temp, owned_by, population, ip):
	self._name = planet_name
	self._rigidbody3d = rigidbody3d
	self._texture = texture
	self._coord = coord
	self._resources = resources
	self._radius = radius
	self._temp = temp
	self._owned_by = owned_by
	self._population = population
	self._ip = ip
