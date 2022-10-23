extends Control
class_name GameDisplay

const Enums = preload("res://script/Enums.gd")

signal go(priorities) # {"fitness": 0, "social": 2, etc etc}
signal accept(event_idx) # index of event in the array sent in display_events()
signal decline(event_idx) 
signal player_apply_status(status_id) # player-triggered status application/removal
signal player_remove_status(status_id)

# interface
func update_health(old_value, new_value):
	pass

# interface	
func update_happiness(old_value, new_value):
	pass
	
# interface
func update_money(old_value, new_value):
	pass

# interface
func add_status(status: Status):
	pass
	
# interface
func remove_status(status: Status):
	pass

# interface
func queue_events(events: Array): # Array(Event resource object) that were drawn this turn
	pass

# interface
func game_ended(ending): # Ending Enum
	pass
