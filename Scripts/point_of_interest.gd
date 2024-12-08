@icon("res://Assets/poi_icon.png")
class_name PointOfInterest extends Area2D

@export var weight: int = 10
@export var release_period: float = 3

@onready var release_timer: Timer = $ReleaseTimer

var exits: Array[ExitDoor] = []
var people_inside: int = 0

const BRNAK_TEMPLATE = preload("res://Scenes/brnak.tscn")

func _ready() -> void:
	PlacesManager.register(self, weight)
	
	release_timer.wait_time = release_period + randf()
	release_timer.timeout.connect(release_person)
	
	self.area_entered.connect(on_area_entered)
	
	for child in get_children():
		if child is ExitDoor:
			exits.append(child)
	
	assert(exits.size() > 0, "Building have at least 1 exit")

func on_area_entered(area: Area2D) -> void:
	var potential_brnak = area.get_parent()
	if potential_brnak is Brnak:
		var brnak = potential_brnak as Brnak
		if brnak.goal == self:
			brnak.queue_free()
			people_inside += 1

func release_person() -> void:
	if people_inside == 0:
		return
	
	people_inside -= 1
	var b = BRNAK_TEMPLATE.instantiate()
	var exit = exits.pick_random()
	
	get_tree().current_scene.add_child(b)
	b.global_position = exit.global_position
	
