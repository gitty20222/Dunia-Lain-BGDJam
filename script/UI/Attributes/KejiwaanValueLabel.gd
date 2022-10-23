extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var simul_node = get_node("%simulation")
	if simul_node != null:
		simul_node.connect("happiness_updated", self, "_on_value_updated")
	pass # Replace with function body.

func _on_value_updated(old, new):
	var new_value = "%" + str(new)
	text = new_value
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
