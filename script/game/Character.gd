extends Node
class_name Character

var active_statuses: Dictionary

enum Aspect {
	Fitness,
	Work,
	Sleep,
	Social
}

onready var aspect_values = {
	Aspect.Fitness : 60.0,
	Aspect.Work : 60.0,
	Aspect.Sleep : 60.0,
	Aspect.Social : 60.0
}

func has_status(status_id: String) -> bool:
	return active_statuses[status_id] != null
	
func add_status(status: Status) -> void:
	active_statuses[status.id] = status

func get_aspect(aspect) -> float:
	return aspect_values[aspect]
