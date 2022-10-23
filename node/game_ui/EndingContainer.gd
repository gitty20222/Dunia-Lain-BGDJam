extends MarginContainer

const Enums = preload("res://script/Enums.gd")

export(Texture) var pic_died: Texture
export(Texture) var pic_depressed: Texture
export(Texture) var pic_destitute: Texture
export(Texture) var pic_healthy: Texture
export(Texture) var pic_happy: Texture
export(Texture) var pic_rich: Texture
export(Texture) var pic_healthy_happy: Texture
export(Texture) var pic_healthy_rich: Texture
export(Texture) var pic_happy_rich: Texture
export(Texture) var pic_healthy_happy_rich: Texture

const title_died := "Meninggal"
const title_depressed := "Depresi"
const title_destitute := "Miskin"

const title_healthy := "Bugar"
const title_happy := "Ceria"
const title_rich := "Kaya Raya"

const desc_died := "Kesadaranku semakin memudar.."
const desc_depressed := "Hidup adalah penderitaan"
const desc_destitute := "Uang..aku butuh uang.."

const desc_healthy := "Badanku terasa sangat segar dan bertenaga"
const desc_happy := "Hidup terasa sangat menyenangkan seperti seharusnya"
const desc_rich := "Uang adalah segalannya"

class Ending:
	var texture: Array
	var title: String
	var description: String
	
	func _init(texture: Array, title: String, description: String):
		self.texture = texture
		self.title = title
		self.description = description

var died := Ending.new([pic_died], title_died, desc_died)

var depressed := Ending.new([pic_depressed], title_depressed, desc_depressed)

var destitute := Ending.new([pic_destitute], title_destitute, desc_destitute)

var healthy := Ending.new([pic_healthy], title_healthy, desc_healthy)

var happy := Ending.new([pic_happy], title_happy, desc_happy)

var rich := Ending.new([pic_rich], title_rich, desc_rich)

var healthy_happy := Ending.new(
	[
		pic_healthy,
		pic_happy
	], 
	title_healthy + ", " + title_happy, 
	desc_happy + "\n" + desc_healthy)

var healthy_rich := Ending.new(
	[
		pic_healthy,
		pic_rich
	],
	title_healthy + ", " + title_rich,
	desc_healthy + "\n" + desc_rich)

var happy_rich := Ending.new(
	[
		pic_happy,
		pic_rich
	],
	title_happy + ", " + title_rich,
	desc_happy + "\n" + desc_rich)

var healthy_happy_rich := Ending.new(
	[
		pic_healthy,
		pic_happy,
		pic_rich
	],
	title_healthy + ", " + title_happy + ", " + title_rich,
	desc_healthy + "\n" + desc_happy + "\n" + desc_rich)

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
	
#	get_node("%TextureRect").texture = ending_data.texture
	if ending_data.texture.size() == 1:
		get_node("%TextureRect").texture = ending_data.texture[0]
	
	if ending_data.texture.size() == 2:
		get_node("%TextureRect").texture = ending_data.texture[0]
		get_node("%TextureRect3").texture = ending_data.texture[1]
		
	if ending_data.texture.size() == 2:
		get_node("%TextureRect").texture = ending_data.texture[0]
		get_node("%TextureRect3").texture = ending_data.texture[1]
		get_node("%TextureRect4").texture = ending_data.texture[2]
		get_node("%TextureRect2").texture = ending_data.texture[3]
	
	get_node("%EndingTitle").text = ending_data.title
	get_node("%EndingText").text = ending_data.description



func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		get_tree().reload_current_scene()
	pass # Replace with function body.
