extends Node
class_name Game

export(Array, String) var starting_status_ids := []

signal save_requested(game_state)
signal game_ended()

const Enums = preload("res://script/Enums.gd")
const simulation_scene = preload("res://node/GameSimulation.tscn")

var data_event_dict: Dictionary
var data_status_dict: Dictionary
var event_list: Array
var status_list: Array

enum State {
	Unititalized,
	Playing
}

var state = State.Unititalized
var sim: GameSimulation
onready var ui: GameDisplay = $UI

func _ready():
	event_list = GameDataLoader.load_events_from("res://game_data/events/")
	status_list = GameDataLoader.load_status_from("res://game_data/status/")
	for event in event_list:
		data_event_dict[event.id] = event
	for status in status_list:
		data_status_dict[status.id] = status
	
func start_from_save(save_data):
	if state != State.Unititalized: return
	var sim = GameSimulation.from(event_list, status_list, save_data, simulation_scene)
	_begin(sim)

func start_new():
	if state != State.Unititalized: return
	var sim = simulation_scene.instance()
	sim.init(event_list, status_list)
	_begin(sim)

func _begin(sim: GameSimulation):
	self.sim = sim
	state = State.Playing
	_connect_sim(sim)
	_connect_ui($UI)
	for status_id in starting_status_ids:
		sim.apply_status(status_id)
	add_child(sim)

func _connect_sim(sim: GameSimulation):
	sim.connect("health_updated", self, "_on_Simulation_health_updated")
	sim.connect("happiness_updated", self, "_on_Simulation_happiness_updated")
	sim.connect("money_updated", self, "_on_Simulation_money_updated")
	sim.connect("fitness_value_updated", self, "_on_Simulation_fitness_value_updated")
	sim.connect("work_value_updated", self, "_on_Simulation_work_value_updated")
	sim.connect("social_value_updated", self, "_on_Simulation_social_value_updated")
	sim.connect("sleep_value_updated", self, "_on_Simulation_sleep_value_updated")
	sim.connect("status_added", self, "_on_Simulation_status_added")
	sim.connect("status_removed", self, "_on_Simulation_status_removed")
	sim.connect("turn_resolved", self, "_on_Simulation_turn_resolved")
	sim.connect("turn_started", self, "_on_Simulation_turn_started")

func _connect_ui(ui: Node):
	ui.connect("accept", self, "_on_UI_accept")
	ui.connect("decline", self, "_on_UI_decline")
	ui.connect("go", self, "_on_UI_go")

func _on_Simulation_health_updated(old, new):
	ui.update_health(old, new)

func _on_Simulation_happiness_updated(old, new):
	ui.update_happiness(old, new)

func _on_Simulation_money_updated(old, new):
	ui.update_money(old, new)

func _on_Simulation_fitness_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_work_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_social_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_sleep_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_status_added(status_id):
	ui.add_status(data_status_dict[status_id])

func _on_Simulation_status_removed(status_id):
	ui.remove_status(data_status_dict[status_id])

func _on_Simulation_turn_resolved(game_state, turn_number):
	emit_signal("save_requested", game_state)

func _on_Simulation_turn_started(game_state, turn_number):
	# Set calendar to be turn number
	pass # Replace with function body.

func _on_UI_accept(event_idx):
	sim.accept_event(event_idx)
	
func _on_UI_decline(event_idx):
	sim.decline_event(event_idx)

func _on_UI_go(priorities):
	var result = sim.play(priorities, 1)
	match result:
		[var event_id]:
			ui.queue_events([event_id])
		var ending:
			ui.game_ended(ending)
