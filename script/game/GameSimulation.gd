extends Node
class_name GameSimulation

signal health_updated(old, new)
signal happiness_updated(old, new)
signal money_updated(old, new)

signal status_added(status_id)
signal status_removed(status_id)
signal status_add_failed(status_id)
signal status_remove_failed(status_id)

signal game_ended()

var event_selector := FortuneWheel.new()

# Game Data
var data_event_list: Array # Array(Event)
var data_status_repo: Dictionary
var event_weighted_pool := [] # Array(Event as FortuneWheelItem)

# Overall Game State
var turn_number := 0
var history := [] # Array(DynamicWheelItem)

# Consumable Resources
var health := 0.7 setget _set_health
var happiness := 0.7 setget _set_happiness
var money := 30.0 setget _set_money

# Current State
var active_statuses := {} # Dictionary(status_id, time_left)
var current_event_idx = null
var event_chosen_this_turn = true

func _set_health(value: float):
	emit_signal("health_updated", health, value)
	health = value
	if (value <= 0):
		emit_signal("game_ended")

func _set_happiness(value: float):
	emit_signal("happiness_updated", happiness, value)
	happiness = value
	if (value <= 0):
		emit_signal("game_ended")

func _set_money(value: float):
	emit_signal("money_updated", money, value)
	money = value
	if (value <= 0):
		emit_signal("game_ended")

func _ready():
	pass
#	# Load Game Data
#	var data_load = GameData.new("res://game_data/")
#	for event in data_load.events:
#		events[event.id] = event
#	for status in data_load.statuses:
#		statuses[status.id] = status
#
#	# Game Setup
#	for event in data_load.events:
#		deck[event.id] = 1

# List of all events are stored, 
# And events are converted to weighted wheel items
func init(event_list: Array, status_list: Array):
	self.data_event_list = event_list
	for event in event_list:
		self.event_weighted_pool.append(event.as_weighted())
	for status in status_list:
		data_status_repo[status.id] = status

func accept_event():
	if event_chosen_this_turn:
		return
	event_chosen_this_turn = true
	
	var event = data_event_list[current_event_idx]
	_process_effects(event.effect_on_accept)
	history.append(event.accept())

func decline_event():
	if event_chosen_this_turn:
		return
	event_chosen_this_turn = true
	
	var event = data_event_list[current_event_idx]
	_process_effects(event.effect_on_decline)
	history.append(event.decline())

func _process_effects(effects: Dictionary):
	var health_to_add = effects["add_health"]
	var happiness_to_add = effects["add_happiness"]
	var money_to_add = effects["add_money"]
	
	var status_id_to_add = effects["status_to_add[id]"]
	var status_id_to_remove = effects["status_to_add[id]"]
	
	if health_to_add and health_to_add != 0:
		_set_health(health + health_to_add)
	
	if happiness_to_add and happiness_to_add != 0:
		_set_happiness(happiness + happiness_to_add)
	
	if money_to_add and money_to_add != 0:
		_set_money(money + money_to_add)
	
	if status_id_to_add:
		var default_duration = data_status_repo[status_id_to_add].default_duration
		if active_statuses.has(status_id_to_add):
			emit_signal("status_add_failed", status_id_to_add)
		else:
			active_statuses[status_id_to_add] = default_duration
			emit_signal("status_added", status_id_to_add)

	if status_id_to_remove:
		if active_statuses.has(status_id_to_remove):
			active_statuses.erase(status_id_to_remove)
			emit_signal("status_removed", status_id_to_remove)
		else:
			emit_signal("status_remove_failed", status_id_to_remove)

# Advance Time
func play(priorities: Dictionary) -> String:
	
	# ENDING
	if turn_number >= 30:
		emit_signal("game_ended")
		return ""
	
	for status_id in active_statuses.keys():
		if data_status_repo[status_id].default_duration != 0:
			active_statuses[status_id] -= 1
			if active_statuses[status_id] <= 0:
				active_statuses.erase(status_id)
	
	for status_id in active_statuses.keys():
		_process_effects(data_status_repo[status_id].per_turn_effects)
	
	var priority_tags = _parse_priorities(priorities)
	var status_tags = _parse_statuses(active_statuses.keys())
	var factors := [] # Array(Dynamic Wheel Item)
	factors.append_array(history)
	factors.append_array(priority_tags)
	factors.append_array(status_tags)
	
	current_event_idx = event_selector.spin_dynamic(event_weighted_pool, factors)
	print(turn_number)
	print(data_event_list[current_event_idx].id)
	# Turn
	turn_number += 1
	event_chosen_this_turn = false
	return data_event_list[current_event_idx].id

func _parse_priorities(priorities: Dictionary) -> Array:
	var fitness_val = priorities.fitness
	var work_val = priorities.work
	var sleep_val = priorities.sleep
	var social_val = priorities.social
	
	var arr := []
	for i in range(fitness_val):
		arr.append("fitness")
	for i in range(work_val):
		arr.append("work")
	for i in range(sleep_val):
		arr.append("sleep")
	for i in range(social_val):
		arr.append("social")
	
	var tag_items := []
	for s in arr:
		var item := DynamicWheelItem.new()
		item.tags_array = [s]
		tag_items.append(item)
	
	return tag_items

func _parse_statuses(statuses: Array) -> Array:
	var tag_items := []
	for status_id in statuses:
		var item := DynamicWheelItem.new()
		item.tags_array = [status_id]
		tag_items.append(item)
	return tag_items
