extends Node

var _places: Array[Node2D]
var _weights: Array[int]
var _weights_sum: int

func register(place: Node2D, weight: int) -> void:
	_places.append(place)
	_weights.append(weight)
	_weights_sum += weight

func get_random() -> Node2D:
	var pick = randi_range(0, _weights_sum)
	
	for i in range(_weights.size()):
		pick -= _weights[i]
		if pick <= 0:
			return _places[i]
	
	print("Weighted pick failed")
	return _places[0]
