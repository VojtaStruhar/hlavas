extends Node

var rng = RandomNumberGenerator.new()

var _places: Array[Node2D]
var _weights: Array[int]

func register(place: Node2D, weight: int) -> void:
	_places.append(place)
	_weights.append(weight)

func get_random() -> Node2D:
	return _places[rng.rand_weighted(_weights)]
	
