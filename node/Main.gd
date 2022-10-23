extends Node

const SAVE_PATH = "user://save"

var jasmani_value_label: Label
var kejiwaan_value_label: Label
var rupiah_value_label: Label

func _ready():
	jasmani_value_label = get_node("%jasmaniValuelabel")
	kejiwaan_value_label = get_node("%kejiwaanValueLabel")
	rupiah_value_label = get_node("%rupiahValueLabel")

	var game_sim = get_node("%Simulation")
	if game_sim != null:
		game_sim.connect("health_updated", self, "_on_Simulation_health_updated")
		game_sim.connect("happiness_updated", self, "_on_Simulation_happiness_updated")
		game_sim.connect("money_updated", self, "_on_Simulation_money_updated")
	pass

func _on_Simulation_health_updated(old, new):
	var new_text = "%" + str(new)
	jasmani_value_label.text = new_text
	pass # Replace with function body.

func _on_Simulation_happiness_updated(old, new):
	var new_text = "%" + str(new)
	kejiwaan_value_label.text = new_text
	pass # Replace with function body.

func _on_Simulation_money_updated(old, new):
	var new_text = "%" + str(new)
	rupiah_value_label.text = new_text
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

func _on_Simulation_turn_resolved(game_state):
	pass # Replace with function body.
