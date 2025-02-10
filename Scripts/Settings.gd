extends Node

signal colored_people_updated
var colored_people: bool = true:
	set(v):
		colored_people = v
		colored_people_updated.emit()

signal background_photo_updated
var background_photo: bool = false:
	set(v):
		background_photo = v
		background_photo_updated.emit()

var background_opacity: float = 0.6
