extends Object
class_name Status

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var id: String
var title: String
"""
affects will be formed in this manner
[attribtutes enum] = changed value ( positive for increment, negative for decrement)
"""
var effects: Dictionary


# Called when the node enters the scene tree for the first time.
func _init(param_id, param_title, param_effects):
	id = param_id
	title = param_title
	effects = param_effects
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
