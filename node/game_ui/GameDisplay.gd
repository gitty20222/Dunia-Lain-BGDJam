extends Control
class_name GameDisplay

const Enums = preload("res://script/Enums.gd")

export(bool) var auto_play_debug := false

signal go(priorities) # {"fitness": 0, "social": 2, etc etc}
signal accept(event_idx) # index of event in the array sent in display_events()
signal decline(event_idx) 
signal player_apply_status(status_id) # player-triggered status application/removal
signal player_remove_status(status_id)

var dhealth := 0
var dhappiness := 0
var dmoney := 0

var dfitness_value := 0
var dwork_value := 0
var dsocial_value := 0
var dsleep_value := 0

var statuses_to_add := [] # Array(Status)
var statuses_to_remove := [] # Array(Status)

var active_events := [] # Array(Event)

func _ready():
	if auto_play_debug:
		$"Autoplay Debug Timer".connect("timeout", self, "_debug_play")
		$"Autoplay Debug Timer".start()

func setup_values(health, happiness, money, fitness_value, work_value, social_value, sleep_value):
	get_node("%JasmaniValueLabel").value += health
	get_node("%KejiwaanValueLabel").value += happiness
	get_node("%RupiahValueLabel").value += money

# interface
func update_health(old_value, new_value):
	dhealth += (new_value - old_value)
	print_debug(dhealth)

# interface
func update_happiness(old_value, new_value):
	dhappiness += (new_value - old_value)
	print_debug(dhappiness)
	
# interface
func update_money(old_value, new_value):
	dmoney += (new_value - old_value)
	print_debug(dmoney)

# interface
func update_fitness_value(old_value, new_value):
	dfitness_value += (new_value - old_value)

func update_work_value(old_value, new_value):
	dwork_value += (new_value - old_value)
	
func update_social_value(old_value, new_value):
	dsocial_value += (new_value - old_value)
	
func update_sleep_value(old_value, new_value):
	dsleep_value += (new_value - old_value)

# interface
func add_status(status: Status):
	statuses_to_add.append(status)
	
# interface
func remove_status(status: Status):
	statuses_to_remove.append(status)

# interface
func queue_events(events: Array): # Array(Event resource object) that were drawn this turn
	active_events = events

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

func _update_ui():
	# Update UI values
	
	# Stats
	get_node("%JasmaniValueLabel").value += dhealth
	get_node("%KejiwaanValueLabel").value += dhappiness
	get_node("%RupiahValueLabel").value += dmoney
	print_debug(dhealth)
	print_debug(dhappiness)
	print_debug(dmoney)
	
	# Aspect Values
	
	# Statuses
	
	# Reset deltas
	dhealth = 0
	dhappiness = 0
	dmoney = 0
	
	dfitness_value = 0
	dwork_value = 0
	dsocial_value = 0
	dsleep_value = 0
	
	statuses_to_add.clear()
	statuses_to_remove.clear()

func _go():
	pass

func _debug_play():
	print("Auto Play")
	emit_signal("go", {
		"fitness" : 2,
		"work" : 2,
		"social" : 2,
		"sleep" : 2
	})
	emit_signal("accept", 0)
	_update_ui()
