extends Node
class_name GameSimulation

export var deck: Deck

enum Stat {
	Fitness,
	Work,
	Sleep,
	Social
}

onready var stats = {
	Stat.Fitness : 0.0,
	Stat.Work : 0.0,
	Stat.Sleep : 0.0,
	Stat.Social : 0.0
}

func _ready():
	var choice := Choice.new("hello")
	pass

func init():
	pass

