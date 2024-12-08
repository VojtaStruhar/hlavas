@icon("res://Assets/station_icon.png")
class_name Station extends Node2D

@export var waiting_area: WaitingArea
@export_range(0, 1, 0.01) var get_in_ratio: float = 0.5
@export_range(0, 1, 0.01) var get_out_ratio: float = 0.5

@onready var train_checker: Area2D = $TrainChecker

func _ready() -> void:
	train_checker.area_entered.connect(on_train_entered)

func on_train_entered(area: Area2D) -> void:
	var train = area.get_parent()
	if train is Train:
		pass

func on_train_exited(area: Area2D) -> void:
	pass


func on_train_stationed(train) -> void:
	pass
