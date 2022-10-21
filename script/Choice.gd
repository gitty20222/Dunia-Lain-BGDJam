extends Object
class_name Choice

var id: String
var title: String
var yes_effect: Dictionary
var no_effect: Dictionary
var yes_child_id: String
var no_child_id: String
var chance: int

func _init():
	id = "" 
	title = "" 
	yes_effect = Dictionary()
	no_effect = Dictionary()
	yes_child_id = ""
	no_child_id = ""
	chance = 0
	pass

func set_id(new_id: String):
	id = new_id
	return self

func set_title(new_title: String):
	title = new_title
	return self

func set_yes_effect(new_yes_effect: Dictionary):
	yes_effect = new_yes_effect
	return self

func set_no_effect(new_no_effect: Dictionary):
	no_effect = new_no_effect
	return self

func set_yes_child_id(new_yes_child_id: String):
	yes_child_id = new_yes_child_id
	return self

func set_no_child_id(new_no_child_id: String):
	no_child_id = new_no_child_id
	return self

func set_chance(new_chance: int):
	chance = new_chance
	return self