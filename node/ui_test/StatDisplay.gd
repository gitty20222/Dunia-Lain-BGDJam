extends Control

export var title: String = "title"

func _ready():
	$Title.text = title

func set_title(param_title: String):
	title = param_title
	$Title.text = title

func set_value(val: float):
	$Value.text = str(val)
