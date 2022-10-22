extends Resource
class_name Status

export(String) var id # Treated as tag
export(String) var title
export(Dictionary) var per_turn_effects: Dictionary = {
	"add_health" : 0,
	"add_happiness": 0,
	"add_money" : 0,
	"add_fitness_value" : 0,
	"add_work_value" : 0,
	"add_social_value" : 0,
	"add_sleep_value" : 0
}
export(int) var default_duration = -1 # 0 means no duration

func _init(id = "", title = "", effects = {}, default_duration = -1):
	self.id = id
	self.title = title
	self.per_turn_effects["status_to_add[id]"] = null
	self.per_turn_effects["status_to_remove[id]"] = null
	self.default_duration = default_duration
