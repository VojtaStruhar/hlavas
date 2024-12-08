@icon("res://Assets/clock_icon.png")
class_name WaitingArea extends Area2D

@export var weight: int = 10

var waiting_people: Array[Brnak] = []

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	PlacesManager.register(self, weight)


func on_area_entered(area: Area2D) -> void:
	var potential_brnak = area.get_parent()
	if potential_brnak is Brnak:
		var b = potential_brnak as Brnak
		if b.goal == self:
			waiting_people.append(b)
			# Place the guy somewhere on the platform
			var col = get_child(0) as CollisionShape2D
			var rect = col.shape as RectangleShape2D
			var random_point = Vector2(randf_range(-0.5, 0.5) * rect.size.x, randf_range(-0.5, 0.5) * rect.size.y) + col.global_position
			b.agent.target_position = random_point
