extends Node
class_name GameSimulation

signal health_updated(old, new)
signal happiness_updated(old, new)
signal money_updated(old, new)

signal fitness_value_updated(old, new)
signal work_value_updated(old, new)
signal social_value_updated(old, new)
signal sleep_value_updated(old, new)

signal status_added(status_id)
signal status_removed(status_id)
signal status_add_failed(status_id)
signal status_remove_failed(status_id)

signal _factors_computed(factors)

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
var health: float = 70/100 setget _set_health
var happiness: float = 70/100 setget _set_happiness
var money := 30.0 setget _set_money

var fitness_value: float = 60/100 setget _set_fitness_value
var work_value: float = 60/100 setget _set_work_value
var social_value: float = 60/100 setget _set_social_value
var sleep_value: float = 70/70 setget _set_sleep_value

# Current State
var active_statuses := {} # Dictionary(status_id, time_remaining(int))
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

func _set_fitness_value(value: float):
	emit_signal("fitness_value_updated", fitness_value, value)
	fitness_value = value

func _set_work_value(value: float):
	emit_signal("work_value_updated", work_value, value)
	work_value = value
	
func _set_social_value(value: float):
	emit_signal("social_value_updated", social_value, value)
	social_value = value
	
func _set_sleep_value(value: float):
	emit_signal("sleep_value_updated", sleep_value, value)
	sleep_value = value

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

# Advance Time
func play(priorities: Dictionary) -> String:
	
	# ENDING
	if turn_number >= 30:
		emit_signal("game_ended")
		return ""
	
	# Remove expired status
	for status_id in active_statuses.keys():
		if data_status_repo[status_id].default_duration != 0:
			active_statuses[status_id] -= 1
			if active_statuses[status_id] <= 0:
				active_statuses.erase(status_id)
	
	# Apply effects of statuses
	for status_id in active_statuses.keys():
		_process_effects(data_status_repo[status_id].per_turn_effects)
	
	# Compute event draw factors
	var factors := [] # Array(Dynamic Wheel Item)
	var priority_tags = _parse_priorities(priorities)
	var status_tags = _parse_statuses(active_statuses.keys())
	var aspect_tags = _parse_aspect_values(
		fitness_value, 
		work_value,
		social_value,
		sleep_value)
	factors.append_array(history)
	factors.append(priority_tags)
	factors.append(status_tags)
	factors.append(aspect_tags)
	emit_signal("_factors_computed", factors)
	current_event_idx = event_selector.spin_dynamic(event_weighted_pool, factors)
	print(turn_number)
	print(data_event_list[current_event_idx].id)
	
	turn_number += 1
	event_chosen_this_turn = false
	return data_event_list[current_event_idx].id

func _get_value_level(percentage: float) -> String:
	if percentage < 0.3: return "low"
	elif percentage < 0.6: return "medium"
	else: return "high"

func _parse_aspect_values(fitness_value: float, work_value: float, social_value: float, sleep_value: float) -> DynamicWheelItem:
	var item := DynamicWheelItem.new()
	item.tags_array = [
		"fitness_" + _get_value_level(fitness_value),
		"work_" + _get_value_level(work_value),
		"social_" + _get_value_level(social_value),
		"sleep_" + _get_value_level(sleep_value)
	]
	return item

func _process_effects(effects: Dictionary) -> void:
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

func _process_priorities(priorities: Dictionary) -> void:
	_process_fitness_priority(priorities["fitness"])
	_process_work_priority(priorities["work"])
	_process_social_priority(priorities["social"])
	_process_sleep_priority(priorities["sleep"])

func _process_fitness_priority(degree_of_priority: int) -> void:
	match degree_of_priority:
		0:
			_add_money(1)
			_add_health_point(1)
			_add_happiness_point(1)
		1:
			_add_health_point(1)
		2:
			_add_money(-1)
			_add_happiness_point(1)
			_add_health_point(1)
			_add_fitness_value_point(1)

func _process_work_priority(degree_of_priority: int) -> void:
	match degree_of_priority:
		0:
			_add_health_point(1)
		1:
			_add_money(4)
		2:
			_add_happiness_point(-1)
			_add_health_point(-1)

func _process_social_priority(degree_of_priority: int) -> void:
	match degree_of_priority:
		0:
			_add_happiness_point(-3)
		1:
			_add_social_value_point(5)
		2:
			_add_happiness_point(2)

func _process_sleep_priority(degree_of_priority: int) -> void:
	match degree_of_priority:
		0:
			_add_health_point(-1)
			_add_happiness_point(-1)
			_set_sleep_value(40/70)
		1:
			_set_sleep_value(70/70)
		2:
			_add_health_point(1)
			_add_happiness_point(1)

func _parse_priorities(priorities: Dictionary) -> DynamicWheelItem:
	var fitness_p = priorities.fitness
	var work_p = priorities.work
	var sleep_p = priorities.sleep
	var social_p = priorities.social
	
	var tagged_item := DynamicWheelItem.new()
	tagged_item.tags_array = [
		"fitness_" + str(fitness_p),
		"work_" + str(work_p),
		"sleep_" + str(sleep_p),
		"social_" + str(social_p)
	]
	
	return tagged_item

func _parse_statuses(status_ids: Array) -> DynamicWheelItem:
	var tagged_item := DynamicWheelItem.new()
	tagged_item.tags_array = status_ids
	return tagged_item

func _add_health_point(amount: float):
	_set_health(health + amount/100)

func _add_happiness_point(amount: float):
	_set_happiness(happiness + amount/100)

func _add_money(amount: float):
	_set_money(money + amount)

func _add_fitness_value_point(amount: float):
	_set_fitness_value(fitness_value + amount/100)
	
func _add_work_value_point(amount: float):
	_set_work_value(work_value + amount/100)
	
func _add_social_value_point(amount: float):
	_set_social_value(social_value + amount/100)
	
func _add_sleep_value_point(amount: float):
	_set_sleep_value(sleep_value + amount/70)
