extends Resource
class_name Event

export(String) var id: String
export(String) var title: String
export(String) var description: String
export(Dictionary) var yes_effects: Dictionary
export(Dictionary) var no_effects: Dictionary
export(int) var base_weight: int
export(String) var yes_child_id: String
export(String) var no_child_id: String
export(Array, String) var tags: Array
export(int) var duration: int
export(Array, String) var categories: Array

func _init(
	p_id = "no_choice", 
	p_title = "noTitle", 
	p_yes_effects = {}, 
	p_no_effects = {},
	p_base_weight = 0,
	p_yes_child_id = "",
	p_no_child_id = "",
	p_tags = [],
	p_duration = 0,
	p_categories = []
	):
		id = p_id
		title = p_title
		yes_effects = p_yes_effects
		no_effects = p_no_effects
		base_weight = p_base_weight
		yes_child_id = p_yes_child_id
		no_child_id = p_no_child_id
		tags = p_tags
		duration = p_duration
		categories = p_categories
