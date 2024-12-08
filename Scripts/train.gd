@icon("res://Assets/tram_icon.png")
class_name Train extends PathFollow2D


const MAX_SPEED = 15

var current_speed = 0
var people_inside = 0

func _ready() -> void:
	loop = false
	progress_ratio = 0
	current_speed = MAX_SPEED


func _process(delta: float) -> void:
	progress += get_speed() * delta

	if progress_ratio >= 1:
		print("Freeing a train with ", people_inside, " people inside!")
		queue_free()


func get_speed() -> float:
	const KMH = 3.6 * 3  # 1m is about 3px here
	return current_speed * KMH


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is SlowDownArea:
		var t = create_tween()
		t.tween_property(self, "current_speed", area.slow_speed, 1.0)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is SlowDownArea:
		var t = create_tween()
		t.tween_property(self, "current_speed", MAX_SPEED, 1.0)
