@icon("res://Assets/guy_icon.png")
class_name Brnak extends Node2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
var goal: Node2D

var SPEED = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SPEED += randi_range(-3, 3)
	
	goal = PlacesManager.get_random()
	print("Heading to ", goal.name)
	
	if goal:
		start.call_deferred()
	else:
		print(name, " has no goal!!!")

func start() -> void:
	agent.target_position = goal.global_position

func _physics_process(delta: float) -> void:
	
	var next_pos = agent.get_next_path_position()
	position = position.move_toward(next_pos, delta * SPEED)
