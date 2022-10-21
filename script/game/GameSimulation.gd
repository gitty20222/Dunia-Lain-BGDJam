extends Node
class_name GameSimulation

signal health_updated(delta)
signal happiness_updated(delta)
signal money_updated(delta)

signal status_added(status_id)
signal status_removed(status_id)
signal status_add_failed(status_id)
signal status_remove_failed(status_id)

var rng = RandomNumberGenerator.new()

# Game Data
var events = {}
var statuses = {}
var events_by_category = {}

# Overall Game State
var deck = {} # Remaining events left
var hand = [] # Queue of upcoming events
var turn_number = 0
var choice_history = []

# Consumable Resources
var health = 0.7
var happiness = 0.7
var money = 30

# Current State
var active_statuses = {}
var current_event_id = null
var event_chosen_this_turn = true
var previous_priority = null

func _ready():
	rng.randomize()
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

func init(events: Dictionary, statuses: Dictionary, deck: Dictionary):
	self.events = events
	self.statuses = statuses
	self.deck = deck
	for event in events.values():
		if event.categories.empty():
			events_by_category["no_category"] = event.id
		else:
			for category in event.categories:
				events_by_category[category] = event.id

func accept_event():
	if event_chosen_this_turn:
		return
	event_chosen_this_turn = true
	
	var event = events[current_event_id]
	_process_effects(event.yes_effects)
	
	choice_history.append({"event_id": event.id, "choice": "yes"})

func decline_event():
	if event_chosen_this_turn:
		return
	event_chosen_this_turn = true
	
	var event = events[current_event_id]
	_process_effects(event.no_effects)
	
	choice_history.append({"event_id": event.id, "choice": "no"})

func _process_effects(effects: Dictionary):
	var health_to_add = effects["add_health"]
	var happiness_to_add = effects["add_happiness"]
	var money_to_add = effects["add_money"]
	
	var status_id_to_add = effects["add_status"]
	var status_id_to_remove = effects["remove_status"]
	
	if health_to_add and health_to_add != 0:
		health += health_to_add
		emit_signal("health_updated", health_to_add)
	
	if happiness_to_add and happiness_to_add != 0:
		happiness += happiness_to_add
		emit_signal("happiness_updated", happiness_to_add)
		
	if money_to_add and money_to_add != 0:
		money += money_to_add
		emit_signal("money_updated", money_to_add)
		
	if status_id_to_add:
		var default_duration = statuses[status_id_to_add].default_duration
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
func play(priorities) -> String:
	# Statuses
	for status_id in active_statuses.keys:
		var status = statuses[status_id]
		if not status: break
		_process_effects(status.effects)
		active_statuses[status_id] -= 1
		if active_statuses[status_id] <= 0:
			active_statuses.erase(status_id)
			emit_signal("status_removed", status_id)
	
	# Apply priorities
	var fitness_index = priorities["fitness"]
	var work_index = priorities["work"]
	var sleep_index = priorities["sleep"]
	var social_index = priorities["social"]
	
	var fitness_weight = fitness_index / 1
	var work_weight = work_index / 4
	var sleep_weight = sleep_index / 4
	var social_weight = social_index / 1.5
	var wildcard_weight = 1 - (fitness_index + work_index + sleep_index + social_index)
	
	var weights = [fitness_weight, work_weight, sleep_weight, social_weight, wildcard_weight]
	weights.sort()
	# Swap the last and middle element
	var temp = weights[2]
	weights[2] = weights[4]
	weights[4] = temp
	# Swap the last and second to last element
	temp = weights[3]
	weights[3] = weights[4]
	weights[4] = temp
	
	var rand = rng.randfn(weights[2], max(weights.max(), weights.min()))
	var last_diff = abs(rand-weights[0])
	var selected_weight = weights[0]
	for weight in weights:
		var diff = abs(rand-weight)
		if diff < last_diff:
			last_diff = diff
			selected_weight = weight
	
	# Regenerate hand from deck
	var selected_category
	match selected_weight:
		fitness_weight:
			selected_category = "fitness"
		work_weight:
			selected_category = "work"
		sleep_weight:
			selected_category = "sleep"
		social_weight:
			selected_category = "social"
		wildcard_weight:
			selected_category = "wildcard"
	var event_id
	if selected_category != "wildcard":
		var category = events_by_category[selected_category]
		event_id = category[rng.randi() % (category.size()-1)]
	else:
		var keys = events_by_category.keys()
		var category = events_by_category[keys[rng.randi() % (keys.size()-1)]]
		event_id = category[rng.randi() % (category.size()-1)]
	hand.append(event_id)
	deck[event_id] -= 1
	# Draw next event from hand
	current_event_id = hand.pop_at(rng.randi() % (hand.size()-1))
	
	# Turn
	turn_number += 1
	
	return current_event_id
