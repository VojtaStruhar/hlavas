@icon("res://Assets/guy_icon.png")
class_name Brnak extends Node2D


@onready var agent: NavigationAgent2D = $NavigationAgent2D
var goal: Node2D:
	set(v):
		goal = v
		update_modulate()

var SPEED = 20
var movement_delta: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SPEED += randi_range(-3, 3)
	goal = PlacesManager.get_random()
	agent.velocity_computed.connect(_on_velocity_computed)
	Settings.colored_people_updated.connect(update_modulate)
	
	if goal:
		start.call_deferred()
	else:
		print(name, " has no goal!!!")

## Kept around because other things already use it. Redundant now.
func start() -> void:
	set_movement_target(goal.global_position)

func _physics_process(delta: float) -> void:
	# Do not query when the map has never synchronized and is empty. (Taken from Godot docs)
	if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
		return
	if agent.is_navigation_finished():
		return

	movement_delta = SPEED * delta
	var next_path_position: Vector2 = agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_delta
	if agent.avoidance_enabled:
		agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func set_movement_target(movement_target: Vector2):
	agent.set_target_position(movement_target)


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)

func _enter_tree() -> void:
	Stats.people_outside += 1

func _exit_tree() -> void:
	Stats.people_outside -= 1

func update_modulate() -> void:
	if Settings.colored_people:
		modulate = goal.visitor_color
	else:
		modulate = Color.WHITE
	
