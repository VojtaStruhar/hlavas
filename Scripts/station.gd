@icon("res://Assets/station_icon.png")
class_name Station extends Node2D

@export var waiting_area: WaitingArea
@export_range(0, 1, 0.01) var get_in_ratio: float = 0.5
@export_range(0, 1, 0.01) var get_out_ratio: float = 0.5

@onready var train_checker: Area2D = $TrainChecker

var train_exits: Array[ExitDoor] = []

const BRNAK = preload("res://Scenes/brnak.tscn")

func _ready() -> void:
	assert(waiting_area != null)
	train_checker.area_entered.connect(on_train_entered)
	for child in get_children():
		if child is ExitDoor:
			train_exits.append(child)

func on_train_entered(area: Area2D) -> void:
	var train = area.get_parent()
	
	if train is Train:
		var arrive_speed = train.current_speed
		var arrive_people_waiting = waiting_area.waiting_people.size()
		var arrive_people_in_train = train.people_inside
		
		train.current_speed = 0
		
		await get_tree().create_timer(1).timeout
		
		for i in range(ceil(arrive_people_in_train * get_out_ratio)):
			var b = BRNAK.instantiate()
			var exit = train_exits.pick_random()
			get_tree().current_scene.add_child.call_deferred(b)
			b.global_position = exit.global_position
			train.people_inside -= 1
			await get_tree().create_timer(0.4).timeout
		
		await get_tree().create_timer(1).timeout
		
		while waiting_area.waiting_people.size() > arrive_people_waiting * get_in_ratio:
			var p = waiting_area.waiting_people.pop_front()
			if not is_instance_valid(p):
				continue
			p.queue_free()
			train.people_inside += 1
			await get_tree().create_timer(0.4).timeout
		
		
		await get_tree().create_timer(1).timeout
		train.current_speed = arrive_speed

func on_train_stationed(train) -> void:
	pass
