@icon("res://Assets/clock_icon.png")
class_name WaitingArea extends Area2D

@export var weight: int = 10
@export var release_time: float = 15
@export var capacity: int = 30

@onready var release_timer: Timer = $ReleaseTimer
@onready var label: Label = $Label

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
		label.text = name + ": " + str(waiting_people.size()) + "/" + str(capacity)
		var b = potential_brnak as Brnak
		if b.goal == self:
			store_person(b)


func store_person(b: Brnak) -> void:
	waiting_people.append(b)
	# Place the guy somewhere on the platform
	var offset = Vector2(randf_range(-0.5, 0.5), randf_range(-0.5, 0.5))
	var within_rect = (offset * waiting_rect.size).rotated(waiting_collider.rotation)
	b.agent.target_position = waiting_collider.global_position + within_rect
	
	if waiting_people.size() >= capacity:
		release_person()

func release_person() -> void:
	var person = waiting_people.pop_front()
	
	if not is_instance_valid(person):
		push_warning("Trying to release invalid person??")
		return
	
	var goal = PlacesManager.get_random()
	while goal == self: # Don't go back to me!!!
		goal = PlacesManager.get_random()
	
	person.goal = goal
	person.start()

func on_release_timeouot() -> void:
	var ppl_before = waiting_people.size()
	waiting_people = waiting_people.filter(is_instance_valid)
	var ppl_after = waiting_people.size()
	
	if ppl_after < ppl_before:
		print("[Cleanup] ", name, " ", ppl_before - ppl_after, " invalid instances")

	if waiting_people.size() > 0:
		release_person()
	
