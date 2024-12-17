@icon("res://Assets/wagon_icon.png")
class_name Wagon extends PathFollow2D

@export var locomotive: Train
@export var wagon_length_px: int = 42

var wagon_index: int

func _ready() -> void:
	wagon_index = locomotive.number_of_wagons
	locomotive.number_of_wagons += 1

func _process(_delta: float) -> void:
	progress = locomotive.progress - (wagon_index + 1) * wagon_length_px
