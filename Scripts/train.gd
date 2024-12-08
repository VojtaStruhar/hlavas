@icon("res://Assets/tram_icon.png")
class_name Train extends PathFollow2D

@export var wait_seconds = 10
@export var initial_people = 20
@export var MAX_SPEED = 12


var people_inside = 0
var current_speed = 0
var number_of_wagons = 0

func _ready() -> void:
	setup()

func setup() -> void:
	progress_ratio = 0
	current_speed = MAX_SPEED
	people_inside = initial_people

func _process(delta: float) -> void:
	progress += get_speed() * delta

	if progress_ratio >= 1:
		current_speed = 0
		progress_ratio = 0
		get_tree().create_timer(wait_seconds).timeout.connect(setup)


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
		t.tween_property(self, "current_speed", MAX_SPEED, 2.0)
