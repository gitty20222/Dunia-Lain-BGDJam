extends Resource
class_name Status

export(String) var id
export(String) var title
export(Dictionary) var effects

func _init(param_id = "no_status", param_title = "noTitle", param_effects = {}):
	id = param_id
	title = param_title
	effects = param_effects
	pass
