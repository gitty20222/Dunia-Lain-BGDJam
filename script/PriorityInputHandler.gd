extends Node

export var dietPriorityStylebox: StyleBoxTexture
export var kerjaPriorityStylebox: StyleBoxTexture
export var tidurPriorityStylebox: StyleBoxTexture
export var sosialPriorityStylebox: StyleBoxTexture
export var emptyPriorityStylebox: StyleBoxEmpty

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_priority_label_gui_input(event: InputEvent, 
									main_priority_name: String, 
									other_priority_name: String, 
									other_priority_name2: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var priority_label: Label = get_node(main_priority_name)
		var highlight_label_name = main_priority_name + "Highlight"
		var highlight_label: Label = priority_label.get_parent().get_node(highlight_label_name)
		
		var other_priority_label: Label = get_node(other_priority_name)
		var other_highlight_label_name = other_priority_name + "Highlight"
		var other_highlight_label: Label = other_priority_label.get_parent().get_node(other_highlight_label_name)

		var other_priority_label2: Label = get_node(other_priority_name2)
		var other_highlight_label_name2 = other_priority_name2 + "Highlight"
		var other_highlight_label2: Label = other_priority_label2.get_parent().get_node(other_highlight_label_name2)

		if not highlight_label.visible:
			get_node("%PriorityClickAudio").play()

			priority_label.visible = false
			highlight_label.visible = true

			other_priority_label.visible = true
			other_highlight_label.visible = false

			other_priority_label2.visible = true
			other_highlight_label2.visible = false
	pass # Replace with function body.
