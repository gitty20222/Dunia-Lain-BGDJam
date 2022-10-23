extends Control
class_name GameDisplay

const Enums = preload("res://script/Enums.gd")

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

# interface
func update_health(old_value, new_value):
	dhealth += (new_value - old_value)

# interface	
func update_happiness(old_value, new_value):
	dhappiness += (new_value - old_value)
	
# interface
func update_money(old_value, new_value):
	dmoney += (new_value - old_value)

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
	pass

func _update_ui():
	# Update UI values
	
	
	# Reset delta
	dhealth = 0
	dhappiness = 0
	dmoney = 0
	
	dfitness_value = 0
	dwork_value = 0
	dsocial_value = 0
	dsleep_value = 0
	
	statuses_to_add.clear()
	statuses_to_remove.clear()
