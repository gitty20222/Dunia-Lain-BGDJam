extends Node

const SAVE_PATH = "user://save.tres"
const main_menu_scene = preload("res://node/game_ui/MainMenu.tscn")
const game_scene = preload("res://node/Game.tscn")
const end_scene = preload("res://node/game_ui/Ending.tscn")

var dir = Directory.new()

enum GameScene {
	MainMenu,
	Ending,
	Game
}

var state
var current_scene: Node

func _ready():
	
	state = GameScene.MainMenu
	var main_menu = main_menu_scene.instance()
	_connect_main_menu(main_menu)
	current_scene = main_menu
	add_child(main_menu)

func _on_Main_Menu_exit_game():
	get_tree().quit()

func _on_Main_Menu_new_game():
	if state != GameScene.MainMenu: return
	
	dir.remove(SAVE_PATH)
	
	state = GameScene.Game
	var main_menu = current_scene
	
	var game = game_scene.instance()
	_connect_game(game)
	current_scene = game
	add_child(game)
	
	main_menu.queue_free()
	
	game.start_new()


func _on_Game_game_ended(ending):
	if state != GameScene.Game: return
	
	state = GameScene.Ending
	var game = current_scene

	var ending_node = end_scene.instance()
	ending_node.set_ending(ending)
	_connect_ending(ending_node)
	current_scene = ending_node
	add_child(ending_node)

	game.queue_free()

func _on_Game_save_requested(save_data):
	$GameSaveManager.write_save(SAVE_PATH, save_data)

func on_Ending_return_to_main_menu():
	state = GameScene.MainMenu
	var ending_node = current_scene
	var main_menu = main_menu_scene.instance()
	_connect_main_menu(main_menu)
	current_scene = main_menu
	add_child(main_menu)
	ending_node.queue_free()

func _connect_main_menu(main_menu):
	main_menu.connect("new_game", self, "_on_Main_Menu_new_game")
	main_menu.connect("exit_game", self, "_on_Main_Menu_exit_game")

func _connect_game(game):
	game.connect("save_requested", self, "_on_Game_save_requested")
	game.connect("game_ended", self, "_on_Game_game_ended")

func _connect_ending(ending):
	ending.connect("return_to_main_menu", self, "on_Ending_return_to_main_menu")
