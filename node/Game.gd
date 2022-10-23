extends Node
class_name Game

signal save_requested(game_state)

const Enums = preload("res://script/Enums.gd")
const simulation_scene = preload("res://node/GameSimulation.tscn")

var data_event_dict: Dictionary
var event_list: Array
var status_list: Array

enum State {
	Unititalized,
	Playing
}

var state = State.Unititalized

func _ready():
	event_list = GameDataLoader.load_events_from("res://game_data/events/")
	status_list = GameDataLoader.load_status_from("res://game_data/status/")

func start_from_save(save_path: String):
	if state != State.Unititalized: return
	var save_data = $SaveManager.read_save(save_path)
	var sim = GameSimulation.from(event_list, status_list, save_data, simulation_scene)
	_begin(sim)

func start_new():
	if state != State.Unititalized: return
	var sim = simulation_scene.instance()
	sim.init(event_list, status_list)
	_begin(sim)

func _begin(sim: GameSimulation):
	state = State.Playing
	_connect_sim(sim)
	_connect_ui($UI)
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
	ui.connect("SIGNAL_NAME", self, "_on_UI_accept")
	ui.connect("SIGNAL_NAME", self, "_on_UI_decline")
	ui.connect("SIGNAL_NAME", self, "_on_UI_go")

func _on_Simulation_health_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_happiness_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_money_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_fitness_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_work_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_social_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_sleep_value_updated(old, new):
	pass # Replace with function body.

func _on_Simulation_status_added(status_id):
	pass # Replace with function body.

func _on_Simulation_status_removed(status_id):
	pass # Replace with function body.

func _on_Simulation_turn_resolved(game_state, turn_number):
	emit_signal("save_requested", game_state)

func _on_Simulation_turn_started(game_state, turn_number):
	# Set calendar to be turn number
	pass # Replace with function body.

func _on_UI_accept(event_idx):
	pass
	
func _on_UI_decline(event_idx):
	pass

func _on_UI_go(priorities):
	pass
