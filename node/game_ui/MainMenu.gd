extends Control
class_name MainMenu

signal new_game()
signal continue_game()
signal exit_game()

func _on_NewGame_button_up():
	emit_signal("new_game")

func _on_Continue_button_up():
	emit_signal("continue_game")

func _on_Quit_button_up():
	emit_signal("exit_game")
