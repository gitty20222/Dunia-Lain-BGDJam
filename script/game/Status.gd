extends Resource
class_name Status

export(String) var id
export(String) var title
export(Dictionary) var effects
export(int) var default_duration # -1 means no duration

func _init(p_id = "no_status", p_title = "noTitle", p_effects = {}, p_default_duration = -1):
	id = p_id
	title = p_title
	effects = p_effects
	default_duration = p_default_duration
