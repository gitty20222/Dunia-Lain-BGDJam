extends Control

var data_event_dict: Dictionary
var event_chosen_this_turn: bool = true

func _ready():
	var events = GameDataLoader.load_events_from("res://game_data/events/")
	$GameSimulation.init(events)
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
	var event_id = $GameSimulation.play({})
	var event = data_event_dict[event_id]
	get_node("%EventLabel").text = event.description
