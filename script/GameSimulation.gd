extends Node
class_name GameSimulation

enum AttributeModifier {
	Fitness,
	Work,
	Sleep,
	Social
}

onready var AttributeModidifierCurrent = {
	AttributeModifier.Fitness : 60.0,
	AttributeModifier.Work : 60.0,
	AttributeModifier.Sleep : 60.0,
	AttributeModifier.Social : 60.0
}

enum Attribute {
	Health,
	Happiness,
	Money,
	Time
}

onready var AttributeCurrent = {
	Attribute.Health: 70.0,
	Attribute.Happiness: 70.0,
	Attribute.Money: 70.0,
	Attribute.Time: 70.0
}

var status_list: Array
var choice_list: Array

func _ready():
	var data = GameData.new("res://game_data/")
	status_list = data.statuses
	choice_list = data.choices

