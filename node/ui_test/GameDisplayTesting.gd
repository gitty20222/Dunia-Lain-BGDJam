extends Control

var data_event_dict: Dictionary
var event_chosen_this_turn: bool = true

func _ready():
	var events = GameDataLoader.load_events_from("res://game_data/events/")
	var statuses = GameDataLoader.load_status_from("res://game_data/status/")
	$GameSimulation.init(events, statuses)
	for event in events:
		data_event_dict[event.id] = event

func _on_Timer_timeout():
	return
	$GameSimulation.health += 1
	$GameSimulation.money += 1
	$GameSimulation.happiness += 1

func _on_GameSimulation_happiness_updated(old, new):
	get_node("%HappinessLabelNumber").text = str(new)

func _on_GameSimulation_health_updated(old, new):
	get_node("%HealthLabelNumber").text = str(new)

func _on_GameSimulation_money_updated(old, new):
	get_node("%MoneyLabelNumber").text = str(new)

func _on_YesButton_button_up():
	$GameSimulation.accept_event()
	event_chosen_this_turn = true

func _on_NoButton_button_up():
	$GameSimulation.decline_event()
	event_chosen_this_turn = true

func _on_GO_button_up():
	# Event has to be accepted or declined
	if not event_chosen_this_turn:
		return
	
	# Priorities must be selected 
	
	# Play out event
	event_chosen_this_turn = false
	var event_id = $GameSimulation.play({
		"fitness" : 1,
		"work" : 0,
		"social" : 2,
		"sleep" : 0
	})
	var event = data_event_dict[event_id]
	get_node("%EventLabel").text = event.description

func _on_GameSimulation__factors_computed(factors):
		var tag_count_result = $GameSimulation.event_selector.count_tags(factors)
		var weight_debug = $GameSimulation.event_selector.get_dynamic_weights_debug($GameSimulation.event_weighted_pool, tag_count_result[0], tag_count_result[1])
		for factor in factors:
			break
			print_debug(factor.tags_array)
		get_node("%DebugInfo").text = "\n\n".join(weight_debug)
