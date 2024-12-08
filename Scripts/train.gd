@icon("res://Assets/tram_icon.png")
class_name Train extends PathFollow2D


@export var tracks: Array[Path2D]

const MAX_SPEED = 2

var current_track_index = 0
var current_track: Path2D = null


func _ready() -> void:
	loop = false
	start.call_deferred()

func start() -> void:
	current_track_index = 0
	current_track = tracks[current_track_index]
	reparent(current_track, false)
	progress_ratio = 0
	
	print(current_track.curve.sample_baked(-0.1))
	print(current_track.curve.sample_baked(0))
	print(current_track.curve.sample_baked(0.1))

func _process(delta: float) -> void:
	progress_ratio += get_speed() * delta
	
	if progress_ratio >= 1:
		next_track()

func next_track() -> void:
	current_track_index += 1
	
	if current_track_index >= tracks.size():
		print("Tram finished!")
		queue_free()
		return
	
	current_track = tracks[current_track_index]
	print("Next track!", current_track.name)
	reparent(current_track, false)
	progress_ratio = 0


func get_speed() -> float:
	return max(sin(progress_ratio * PI), 0.01)
