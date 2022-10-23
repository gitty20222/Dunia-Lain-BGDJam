extends Node

const SAVE_PATH = "user://save"

func _ready():
	pass

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
	$SaveManager.write_save(SAVE_PATH, game_state)

func _on_Simulation_turn_started(game_state, turn_number):
	# Set calendar to be turn number
	pass # Replace with function body.
