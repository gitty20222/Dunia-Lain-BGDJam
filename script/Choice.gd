extends Resource
class_name Choice

export(String) var id: String
export(String) var title: String
export(String) var description: String
export(Dictionary) var yes_effects: Dictionary
export(Dictionary) var no_effects: Dictionary
export(String) var yes_child_id: String
export(String) var no_child_id: String
export(int) var weight: int

func _init(
	p_id = "no_choice", 
	p_title = "noTitle", 
	p_yes_effects = {}, 
	p_no_effects = {},
	p_weight = 0,
	p_yes_child_id = "",
	p_no_child_id = ""
	):
		id = p_id
		title = p_title
		yes_effects = p_yes_effects
		no_effects = p_no_effects
		weight = p_weight
		yes_child_id = p_yes_child_id
		no_child_id = p_no_child_id
		
