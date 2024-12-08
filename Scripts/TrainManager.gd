extends Node

const SALINA = preload("res://Scenes/salina.tscn")

var _rails: Array[Node2D] = []

var people_balance = 0;

func register(railway: Node2D) -> void:
	_rails.append(railway)

func deploy_random() -> void:
	var salina = SALINA.instantiate()
	salina.people_inside = 20
	var rails = _rails.pick_random() as Node2D
	rails.add_child(salina)
	print("Spawned train with ", salina.people_inside, " people onto ", rails.name)
