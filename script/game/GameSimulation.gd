extends Node
class_name GameSimulation

const Enums = preload("res://script/Enums.gd")

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

signal turn_resolved(game_state, turn_number)
signal turn_started(game_state, turn_number)

signal _factors_computed(factors)

var event_selector := FortuneWheel.new()

# Game Data
var data_event_list: Array # Array(Event)
var data_event_repo: Dictionary # Dictionary(EventId to Event)
var data_status_repo: Dictionary # Dictionary(StatusId to Status)
var event_weighted_pool := [] # Array(Event as FortuneWheelItem)

# Overall Game State
var turn_number := 1

# Consumable Resources

var health: int setget _set_health
var happiness: int setget _set_happiness
var money: int setget _set_money

var fitness_value: int setget _set_fitness_value
var work_value: int setget _set_work_value
var social_value: int setget _set_social_value
var sleep_value: int setget _set_sleep_value

# Current State
var event_tag_set := {} #(Dictionary of tags [set])
var active_statuses := {} # Dictionary(status_id, time_remaining(int))

# Event State
var n_events_this_turn := 0
var active_events := [] # Array (Event Id)
var event_resolved := [] # Array (Event Status)

# Logging
var event_history := [] # Array (Event Id)

func _set_health(value: int):
	value = clamp(value, 0, 100)
	emit_signal("health_updated", health, value)
	health = value

func _set_happiness(value: int):
	value = clamp(value, 0, 100)
	emit_signal("happiness_updated", happiness, value)
	happiness = value

func _set_money(value: int):
	emit_signal("money_updated", money, value)
	money = value

func _set_fitness_value(value: int):
	value = clamp(value, 0, 100)
	emit_signal("fitness_value_updated", fitness_value, value)
	fitness_value = value

func _set_work_value(value: int):
	value = clamp(value, 0, 100)
	emit_signal("work_value_updated", work_value, value)
	work_value = value
	
func _set_social_value(value: int):
	value = clamp(value, 0, 100)
	emit_signal("social_value_updated", social_value, value)
	social_value = value
	
func _set_sleep_value(value: int):
	value = clamp(value, 0, 70)
	emit_signal("sleep_value_updated", sleep_value, value)
	sleep_value = value

static func from(event_list: Array, status_list: Array, save: GameStateData, scene) -> GameSimulation:
	var sim = scene.instance()
	sim.init(event_list, status_list)
	sim.turn_number = save.turn_number
	sim.health = save.health
	sim.happiness = save.happiness
	sim.money = save.money
	sim.fitness_value = save.fitness_value
	sim.work_value = save.work_value
	sim.social_value = save.social_value
	sim.sleep_value = save.sleep_value
	sim.event_tag_set = save.event_tag_set.duplicate()
	sim.active_statuses = save.active_statuses.duplicate()
	sim.n_events_this_turn = save.n_events_this_turn
	sim.active_events = save.active_events.duplicate()
	sim.event_history = save.event_history.duplicate()
	
	var arr = []
	for event in range(save.n_events_this_turn):
		arr.append(Enums.EventStatus.Unresolved)
	sim.event_resolved = arr
	
	return sim

# List of all events are stored, 
# And events are converted to weighted wheel items
# Dictionary of initial values
func init(event_list: Array, status_list: Array, initial_values: Dictionary):
	# Initial values
	_set_health(initial_values["health"])
	_set_happiness(initial_values["happiness"])
	_set_money(initial_values["money"])
	
	_set_fitness_value(initial_values["fitness"])
	_set_work_value(initial_values["work"])
	_set_social_value(initial_values["social"])
	_set_sleep_value(initial_values["sleep"])
	
	self.data_event_list = event_list
	for event in event_list:
		self.event_weighted_pool.append(event.as_weighted())
		self.data_event_repo[event.id] = event
	assert(data_event_repo.keys().size() == event_weighted_pool.size(), "Make sure all event IDs are unique. Event database doesn't match event list.")
	for status in status_list:
		data_status_repo[status.id] = status
	assert(data_status_repo.keys().size() == status_list.size(), "Make sure all status IDs are unique.")

func apply_status(status_id: String):
	_try_add_status(status_id)

func remove_status(status_id: String):
	_try_remove_status(status_id)

func accept_event(event_idx: int):
	if event_idx < 0 or event_idx >= n_events_this_turn:
		return
	
	if event_resolved[event_idx] != Enums.EventStatus.Unresolved:
		return
	
	event_resolved[event_idx] = Enums.EventStatus.Accepted

func decline_event(event_idx: int):
	if event_idx < 0 or event_idx >= n_events_this_turn:
		return
	
	if event_resolved[event_idx] != Enums.EventStatus.Unresolved:
		return
	
	event_resolved[event_idx] = Enums.EventStatus.Declined

# Advance Time
# Returns next list of events OR Enum for gameover/ending
func play(priorities: Dictionary, events_to_draw: int):
	
	# Decline any unresolved events
	for i in range(n_events_this_turn):
		if event_resolved[i] == Enums.EventStatus.Unresolved:
			decline_event(i)
	
	# RESOLVE THE TURN
	
	# Process events
	for i in range(n_events_this_turn):
		var event = data_event_repo[active_events[i]]
		event_history.append(event.id)
		match event_resolved[i]:
			Enums.EventStatus.Accepted:
				_process_effects(event.effect_on_accept)
				for tag in event.add_tags_on_accept:
					event_tag_set[tag] = true
				for tag in event.remove_tags_on_accept:
					if event_tag_set.has(tag):
						event_tag_set.erase(tag)
			Enums.EventStatus.Declined:
				_process_effects(event.effect_on_decline)
				for tag in event.add_tags_on_decline:
					event_tag_set[tag] = true
				for tag in event.remove_tags_on_decline:
					if event_tag_set.has(tag):
						event_tag_set.erase(tag)
	
	# Remove expired status
	for status_id in active_statuses.keys():
		if data_status_repo[status_id].default_duration != -1: 
			active_statuses[status_id] -= 1
			if active_statuses[status_id] <= 0:
				_try_remove_status(status_id)
	
	# Apply effects of statuses
	for status_id in active_statuses.keys():
		_process_effects(data_status_repo[status_id].per_turn_effects)
	
	# GAME OVER
	if health <= 0:
		 return Enums.Ending.GameOver_Died
	if happiness <= 0:
		 return Enums.Ending.GameOver_Depressed
	if money < 0:
		 return Enums.Ending.GameOver_Destitute
	
	# Apply effects of priorities
	_process_priorities(priorities)
	
	# ENDING
	if turn_number > 30:
		 return _process_ending()
	
	# Turn has been resolved
	emit_signal("turn_resolved", GameStateData.new(self), turn_number)
	
	# START OF NEXT TURN
	n_events_this_turn = events_to_draw
	active_events.clear()
	event_resolved.clear()
	active_events.resize(n_events_this_turn)
	event_resolved.resize(n_events_this_turn)
	
	# Compute event draw factors
	var priority_tags = _parse_priorities(priorities)
	var status_tags = _parse_statuses(active_statuses.keys())
	var aspect_tags = _parse_aspect_values(
		fitness_value, 
		work_value,
		social_value,
		sleep_value)
	var stat_tags = _parse_stats(health, happiness, money)
	var event_tags = _parse_event_tags(event_tag_set.keys())
	
	var factors = [ # Array(Dynamic Wheel Item)
			priority_tags,
			status_tags,
			aspect_tags,
			stat_tags,
			event_tags
		]
	
	emit_signal("_factors_computed", factors)
	
	var event_indexes = event_selector.spin_dynamic_batch(event_weighted_pool, factors, events_to_draw)
	for i in range(events_to_draw):
		active_events[i] = data_event_list[event_indexes[i]].id
		event_resolved[i] = Enums.EventStatus.Unresolved
	turn_number += 1
	
	emit_signal("turn_started", GameStateData.new(self), turn_number)
	
	return active_events

func _process_effects(effects: Dictionary) -> void:
	var health_to_add = effects.get("add_health") 
	var happiness_to_add = effects.get("add_happiness")
	var money_to_add = effects.get("add_money")
	
	var fitness_value_to_add = effects.get("add_fitness_value")
	var work_value_to_add = effects.get("add_work_value")
	var social_value_to_add = effects.get("add_social_value")
	var sleep_value_to_add = effects.get("add_sleep_value")
	
	var status_ids_to_add = effects.get("statuses_to_add[id]")
	var status_ids_to_remove = effects.get("statuses_to_remove[id]")
	
	if health_to_add and health_to_add != 0:
		_set_health(health + health_to_add)
	
	if happiness_to_add and happiness_to_add != 0:
		_set_happiness(happiness + happiness_to_add)
	
	if money_to_add and money_to_add != 0:
		_set_money(money + money_to_add)
	
	if fitness_value_to_add and fitness_value_to_add != 0:
		_add_fitness_value_point(fitness_value_to_add)
	
	if work_value_to_add and work_value_to_add != 0:
		_add_work_value_point(work_value_to_add)
	
	if social_value_to_add and social_value_to_add != 0:
		_add_social_value_point(social_value_to_add)
	
	if sleep_value_to_add and sleep_value_to_add != 0:
		_add_sleep_value_point(sleep_value_to_add)
	
	if status_ids_to_add:
		for status_id in status_ids_to_add:
			var default_duration = data_status_repo[status_id].default_duration
			if active_statuses.has(status_id):
				emit_signal("status_add_failed", status_id)
			else:
				active_statuses[status_id] = default_duration
				emit_signal("status_added", status_id)
	
	if status_ids_to_remove:
		for status_id in status_ids_to_remove:
			if active_statuses.has(status_id):
				active_statuses.erase(status_id)
				emit_signal("status_removed", status_id)
			else:
				emit_signal("status_remove_failed", status_id)

func _process_ending():
	var vhealth = health
	var vhappiness = happiness
	var vmoney = clamp(money/4, 0, 100)
	
	# All same
	if vhealth == vhappiness and vhealth == vmoney:
		return Enums.Ending.HealthyHappyRich
	# Health distinct
	elif vhappiness == vmoney:
		if vhealth < vhappiness:
			return Enums.Ending.HappyRich
		else:
			return Enums.Ending.Healthy
	# Happiness distinct
	elif vhealth == vmoney:
		if vhappiness < vhealth:
			return Enums.Ending.HealthyRich
		else:
			return Enums.Ending.Happy
	# Money distinct
	elif vhealth == vhappiness:
		if vmoney < vhealth:
			return Enums.Ending.HealthyHappy
		else:
			return Enums.Ending.Rich
	# All distinct
	else:
		var maximum = max(max(vhealth, happiness), vmoney)
		match maximum:
			vhealth:
				return Enums.Ending.Healthy
			vhappiness:
				return Enums.Ending.Happy
			_:
				return Enums.Ending.Rich
	
	

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
			_set_sleep_value(40)
		1:
			_set_sleep_value(70)
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
		"fitness_pr" + Enums.str_short_priority(fitness_p),
		"work_pr" + Enums.str_short_priority(work_p),
		"sleep_pr" + Enums.str_short_priority(sleep_p),
		"social_pr" + Enums.str_short_priority(social_p)
	]
	
	return tagged_item

func _parse_event_tags(tag_strings: Array) -> DynamicWheelItem:
	var tagged_item := DynamicWheelItem.new()
	tagged_item.tags_array = tag_strings
	return tagged_item

func _parse_statuses(status_ids: Array) -> DynamicWheelItem:
	var tagged_item := DynamicWheelItem.new()
	tagged_item.tags_array = status_ids
	return tagged_item

func _parse_aspect_values(fitness_value: int, work_value: int, social_value: int, sleep_value: int) -> DynamicWheelItem:
	var item := DynamicWheelItem.new()
	item.tags_array = [
		"fitness_" + _get_value_level(fitness_value),
		"work_" + _get_value_level(work_value),
		"social_" + _get_value_level(social_value),
		"sleep_" + _get_value_level(sleep_value),
		"fitness_" + _get_value_flat(fitness_value),
		"work_" + _get_value_flat(work_value),
		"social_" + _get_value_flat(social_value),
		"sleep_" + _get_value_flat(sleep_value)
	]
	return item

func _parse_stats(health: int, happiness: int, money: int) -> DynamicWheelItem:
	var item := DynamicWheelItem.new()
	item.tags_array = [
		"health_" + _get_value_level(health),
		"happiness_" + _get_value_level(happiness),
		"money_" + _get_value_level(money),
		"health_" + _get_value_flat(health),
		"happiness_" + _get_value_flat(happiness),
		"money_" + _get_value_flat(money),
	]
	return item

func _get_value_level(percentage) -> String:
	if percentage <= 33: return "low"
	elif percentage <= 66: return "medium"
	else: return "high"

func _get_value_flat(percentage) -> String:
	return str(percentage)

func _try_add_status(status_id: String):
	if active_statuses.has(status_id):
		emit_signal("status_add_failed")
	else:
		active_statuses[status_id] = data_status_repo[status_id].default_duration
		emit_signal("status_added")

func _try_remove_status(status_id: String):
	if active_statuses.has(status_id):
		active_statuses.erase(status_id)
		emit_signal("status_removed")
	else:
		emit_signal("status_remove_failed")

func _add_health_point(amount: int):
	_set_health(health + amount)

func _add_happiness_point(amount: int):
	_set_happiness(happiness + amount)

func _add_money(amount: int):
	_set_money(money + amount)

func _add_fitness_value_point(amount: int):
	_set_fitness_value(fitness_value + amount)
	
func _add_work_value_point(amount: int):
	_set_work_value(work_value + amount)
	
func _add_social_value_point(amount: int):
	_set_social_value(social_value + amount)
	
func _add_sleep_value_point(amount: int):
	_set_sleep_value(sleep_value + amount)
