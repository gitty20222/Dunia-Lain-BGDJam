extends Control
class_name GameDisplay

const Enums = preload("res://script/Enums.gd")

signal go(priorities) # {"fitness": 0, "social": 2, etc etc}
signal accept(event_idx) # index of event in the array sent in display_events()
signal decline(event_idx) 
signal player_apply_status(status_id) # player-triggered status application/removal
signal player_remove_status(status_id)
signal return_to_main_menu()

#signal for game display internals


#Event Queue
var event_queue := [] # Array(Event)
var current_event_idx := 0 # Index of current event (displayed on UI)
var n_events_this_turn := 0 # Number of events drawn on this turn

#Attributes
var health: Label
var happiness: Label
var money: Label

#Secondary Attrbibutes
var diet_value: Label
var kerja_value: Label
var tidur_value: Label
var sosial_value: Label

#priority
var diet_priority := 0
var kerja_priority := 0
var tidur_priority := 0
var sosial_priority := 0

#Status
var masakSendiriIcon: TextureRect
var makanBuahIcon: TextureRect
var makanLuarIcon: TextureRect
var smokerIcon: TextureRect
var naikGajiIcon: TextureRect
var naikJabatanIcon: TextureRect
var lihatHpIcon: TextureRect
var insomniaIcon: TextureRect
var gymMemberIcon: TextureRect

func _ready():
	#set attributes
	health = get_node("%JasmaniValueLabel")
	happiness = get_node("%KejiwaanValueLabel")
	money = get_node("%RupiahValueLabel")
	
	#set second attributes
	diet_value = get_node("%DietValueLabel")
	kerja_value = get_node("%KerjaValueLabel")
	tidur_value = get_node("%TidurValueLabel")
	sosial_value = get_node("%SosialValueLabel")
	
	#set status
	masakSendiriIcon = get_node("%MasakSendiriStatus")
	makanBuahIcon = get_node("%MakanBuahStatus")
	makanLuarIcon = get_node("%MakanLuarStatus")
	smokerIcon = get_node("%SmokerStatus")
	naikGajiIcon = get_node("%NaikGajiStatus")
	naikJabatanIcon = get_node("%NaikJabatanStatus")
	lihatHpIcon = get_node("%LihatHpStatus")
	insomniaIcon = get_node("%InsomniaStatus")
	gymMemberIcon = get_node("%GymMemberStatus")

# interface
func update_health(new_value):
	money.text = "%" + str(new_value)

# interface	
func update_happiness(new_value):
	happiness.text = "%" + str(new_value)
	
# interface
func update_money(new_value):
	money.text = str(new_value)

#interface
func update_fitness(new_value):
	diet_value.text = str(new_value)
	pass

func update_work(new_value):
	kerja_value.text = str(new_value)
	pass

func update_sleep(new_value):
	tidur_value.text = str(new_value)
	pass

func update_social(new_value):
	sosial_value.text = str(new_value)
	pass

# interface
func add_status(status: Status):
	if status.id.find("status_jabatan") != -1:
		naikJabatanIcon.visible = true
	if status.id.find("status_makanbuah") != -1:
		makanBuahIcon.visible = true
	if status.id.find("status_makansendiri") != -1:
		masakSendiriIcon.visible = true
	if status.id.find("status_makandiluar") != -1:
		makanLuarIcon.visible = true
	if status.id.find("status_merokok") != -1:
		smokerIcon.visible = true
	if status.id.find("status_naikgaji") != -1:
		naikGajiIcon.visible = true
		
func remove_status(status: Status):
	if status.id.find("status_jabatan") != -1:
		naikJabatanIcon.visible = false
	if status.id.find("status_makanbuah") != -1:
		makanBuahIcon.visible = false
	if status.id.find("status_makansendiri") != -1:
		masakSendiriIcon.visible = false
	if status.id.find("status_makandiluar") != -1:
		makanLuarIcon.visible = false
	if status.id.find("status_merokok") != -1:
		smokerIcon.visible = false
	if status.id.find("status_naikgaji") != -1:
		naikGajiIcon.visible = false
	if status.id.find("status_liathpsebelumtidur") != -1:
		lihatHpIcon.visible = false
	if status.id.find("status_membershipgym") != -1:
		gymMemberIcon.visible = false
	pass

# interface
func queue_events(events: Array): # Array(Event resource object) that were drawn this turn
	event_queue = events
	current_event_idx = 0
	n_events_this_turn = events.size()
	
	# TODO: Display the first event
	
	_display_event()

# interface
func game_ended(ending): # Ending Enum
	match ending:
		Enums.Ending.GameOver_Died:
			pass
		Enums.Ending.GameOver_Depressed:
			pass
		Enums.Ending.GameOver_Destitute:
			pass
		Enums.Ending.Healthy:
			pass
		Enums.Ending.Happy:
			pass
		Enums.Ending.Rich:
			pass
		Enums.Ending.HealthyHappy:
			pass
		Enums.Ending.HealthyRich:
			pass
		Enums.Ending.HappyRich:
			pass
		Enums.Ending.HealthyHappyRich:
			pass

#handle input
const maximum_overall_priority := 5 # 2 highs, 1 medium and 1 low, at the most extreme

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

func _on_change_diet_priority(event: InputEvent, new_value: int, main_name: String, other_name1: String, other_name2: String):
	if kerja_priority + sosial_priority + tidur_priority + new_value <= maximum_overall_priority:
		diet_priority = new_value
		_on_priority_label_gui_input(event, main_name, other_name1, other_name2)
		# Update highlight

func _on_change_kerja_priority(event: InputEvent, new_value: int, main_name: String, other_name1: String, other_name2: String):
	if diet_priority + sosial_priority + tidur_priority + new_value <= maximum_overall_priority:
		kerja_priority = new_value
		_on_priority_label_gui_input(event, main_name, other_name1, other_name2)

func _on_change_tidur_priority(event: InputEvent, new_value: int, main_name: String, other_name1: String, other_name2: String):
	if diet_priority + sosial_priority + kerja_priority + new_value <= maximum_overall_priority:
		tidur_priority = new_value
		_on_priority_label_gui_input(event, main_name, other_name1, other_name2)

func _on_change_sosial_priority(event: InputEvent, new_value: int, main_name: String, other_name1: String, other_name2: String):
	if diet_priority + sosial_priority + kerja_priority + new_value <= maximum_overall_priority:
		sosial_priority = new_value
		_on_priority_label_gui_input(event, main_name, other_name1, other_name2)

func _on_next_pressed(event: InputEvent):
	if current_event_idx < event_queue.size():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("go", {
			"fitness": diet_priority,
			"work": kerja_priority,
			"sleep": tidur_priority,
			"social": sosial_priority
		})

func _on_accept_pressed(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("accept", current_event_idx)
		current_event_idx += 1
		_display_event()

func _on_decline_pressed(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("decline", current_event_idx)
		current_event_idx += 1
		_display_event()


#inner function

func _display_event():
	var event_container = get_node("%VAcara")
	
	if current_event_idx >= event_queue.size():
		event_container.visible = false
		return
		
	var current_event: Event = event_queue[current_event_idx]
	
	
	event_container.visible = true
	
	var event_title = get_node("%AcaraTitle")
	
	event_title.text = current_event.title
	
	var event_description = get_node("%AcaraDescription")
	
	event_description.text = current_event.description
	
	get_node("%VTolak").visible = not current_event.auto_accept
