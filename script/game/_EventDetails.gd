extends Resource
class_name EventDetails

export(String) var title: String
export(String, MULTILINE) var description: String

func _init(title = "", description = ""):
	self.title = title
	self.description = description
