extends Label

var value:int setget _set_value

func _set_value(val: int):
	text = str(val) + "%"
	value = val
