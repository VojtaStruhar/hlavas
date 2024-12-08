@icon("res://Assets/clock_icon.png")
class_name WaitingArea extends Area2D

@export var weight: int = 10

@onready var release_timer: Timer = $ReleaseTimer

var waiting_people: Array[Brnak] = []
var waiting_collider: CollisionShape2D
var waiting_rect: RectangleShape2D

func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	release_timer.wait_time += randf()
	release_timer.timeout.connect(on_release_timeouot)
	
	for child in get_children():
		if child is CollisionShape2D:
			waiting_collider = child
			assert(child.shape is RectangleShape2D, "Waiting areas have to be rectangles")
			waiting_rect = child.shape
			break
	
	assert(waiting_rect != null, "Waiting are has to have a collision shape")
	
	PlacesManager.register(self, weight)


func on_area_entered(area: Area2D) -> void:
	var potential_brnak = area.get_parent()
	if potential_brnak is Brnak:
		var b = potential_brnak as Brnak
		if b.goal == self:
			store_person(b)


func store_person(b: Brnak) -> void:
	print(name, " Storing person")
	waiting_people.append(b)
	# Place the guy somewhere on the platform
	var offset = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	b.agent.target_position = waiting_collider.global_position + offset * waiting_rect.size


func release_person() -> void:
	print(name, " Releasing person")
	var person = waiting_people.pop_front() as Brnak
	var goal = PlacesManager.get_random()
	
	while goal == self: # Don't go back to me!!!
		goal = PlacesManager.get_random()
	
	person.goal = goal
	person.start()

func on_release_timeouot() -> void:
	if waiting_people.size() > 0:
		release_person()
