extends MarginContainer

const Enums = preload("res://script/Enums.gd")

class Ending:
	var texture: Texture
	var title: String
	var description: String
	
	func _init(texture: Texture, title: String, description: String):
		self.texture = texture
		self.title = title
		self.description = description

var died := Ending.new()

var depressed := Ending.new()

var destitute := Ending.new()

var healthy := Ending.new()

var happy := Ending.new()

var rich := Ending.new()

var healthy_happy := Ending.new()

var healthy_rich := Ending.new()

var happy_rich := Ending.new()

var healthy_happy_rich := Ending.new()

func set_ending(ending):
	var ending_data: Ending
	match ending:
		Enums.Ending.GameOver_Died:
			ending_data = died
		Enums.Ending.GameOver_Depressed:
			ending_data = depressed
		Enums.Ending.GameOver_Destitute:
			ending_data = destitute
		Enums.Ending.Healthy:
			ending_data = healthy
		Enums.Ending.Happy:
			ending_data = happy
		Enums.Ending.Rich:
			ending_data = rich
		Enums.Ending.HealthyHappy:
			ending_data = healthy_happy
		Enums.Ending.HealthyRich:
			ending_data = healthy_rich
		Enums.Ending.HappyRich:
			ending_data = happy_rich
		Enums.Ending.HealthyHappyRich:
			ending_data = healthy_happy_rich
			
	get_node("%TextureRect").texture = ending_data.texture
	get_node("%EndingTitle").text = ending_data.title
	get_node("%EndingText").text = ending_data.description
