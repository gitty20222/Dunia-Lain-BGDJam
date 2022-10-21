extends Node
class_name GameSimulation

#export var deck: Deck

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

func _ready():
	initialize_status_list()
	pass

func initialize_status_list():
	var files = list_files_in_directory("res://status")

	for file in files:
		var f := File.new()
		var err = f.open("res://status/" + file, File.READ)
		if err != null:
			get_tree().quit()
		var file_result = parse_json(f.get_as_text())

		print(file_result)

		var new_status := Status.new(file_result["id"], file_result["title"], file_result["effects"])

		status_list.append(new_status)
	pass

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
