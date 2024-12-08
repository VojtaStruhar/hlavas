@icon("res://Assets/rails_icon.png")
class_name Railway extends Path2D


func _ready() -> void:
	TrainManager.register(self)
