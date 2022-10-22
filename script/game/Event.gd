extends Resource
class_name Event

export(String) var id: String = ""
export(String) var title: String = ""
export(String, MULTILINE) var description: String = ""
export(int) var duplicates: int = 1
export(Array, String) var required_tags_to_trigger: Array = []
export(bool) var tag_all_copies: bool = true
export(int) var base_weight: int = 10
export(String, MULTILINE) var multiplier_per_tag = ""
export(String, MULTILINE) var multiplier_if_tag_present = ""
export(String, MULTILINE) var multiplier_if_tag_not_present = ""
export(String, MULTILINE) var max_tags_present = ""
export(String, MULTILINE) var min_tags_present = ""

export(Dictionary) var effect_on_accept: Dictionary = {
	"add_health" : 0,
	"add_happiness": 0,
	"add_money" : 0,
	"status_to_add[id]" : "",
	"status_to_remove[id]" : ""
}
export(Array, String) var tags_on_accept: Array = []

export(Dictionary) var effect_on_decline: Dictionary = {
	"add_health" : 0,
	"add_happiness": 0,
	"add_money" : 0,
	"status_to_add[id]" : "",
	"status_to_remove[id]" : ""
}
export(Array, String) var tags_on_decline: Array = []

func as_weighted() -> DynamicWheelItem:
	var weighted := DynamicWheelItem.new()
	weighted.list_item_delimeter = " "
	weighted.list_row_delimeter = ";"
	weighted.max_duplicates = duplicates
	weighted.requires_one_of_tags_array = required_tags_to_trigger
	weighted.tag_all_copies = tag_all_copies
	weighted.base_weight = base_weight
	weighted.multiplier_per_tag = multiplier_per_tag
	weighted.multiplier_if_tag_present = multiplier_if_tag_present
	weighted.multiplier_if_tag_not_present = multiplier_if_tag_not_present
	weighted.max_tags_present = max_tags_present
	weighted.min_tags_present = min_tags_present
	return weighted

func accept() -> DynamicWheelItem:
	var history := DynamicWheelItem.new()
	history.tags_array = tags_on_accept
	return history

func decline() -> DynamicWheelItem:
	var history := DynamicWheelItem.new()
	history.tags_array = tags_on_decline
	return history
