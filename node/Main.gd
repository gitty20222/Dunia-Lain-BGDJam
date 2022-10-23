extends Node

const SAVE_PATH = "user://save.tres"
const main_menu_scene = preload("res://node/MainMenu.tscn")
const game_scene = preload("res://node/Game.tscn")

var dir = Directory.new()

enum GameScene {
	MainMenu,
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

func _on_Main_Menu_reset_game():
	dir.remove(SAVE_PATH)

func _on_Main_Menu_play_game():
	if state != GameScene.MainMenu: return
	state = GameScene.Game
	var main_menu = current_scene
	
	var game = game_scene.instance()
	_connect_game(game)
	current_scene = game
	add_child(game)
	
	main_menu.queue_free()
	
	if dir.file_exists(SAVE_PATH):
		var save_data = $GameSaveManager.read_save(SAVE_PATH)
		game.start_from_save(save_data)
	else:
		game.start_new()

func _on_Game_game_ended():
	if state != GameScene.Game: return
	state = GameScene.MainMenu
	var game = current_scene
	
	var main_menu = main_menu_scene.instance()
	_connect_main_menu(main_menu)
	current_scene = main_menu
	add_child(main_menu)
	
	game.queue_free()

func _on_Game_save_requested(save_data):
	$GameSaveManager.write_save(SAVE_PATH)

func _connect_main_menu(main_menu):
	main_menu.connect("play_game", self, "_on_Main_Menu_play_game")
	main_menu.connect("reset_game", self, "_on_Main_Menu_reset_game")
	main_menu.connect("exit_game", self, "_on_Main_Menu_exit_game")

func _connect_game(game):
	game.connect("save_requested", self, "_on_Game_save_requested")
	game.connect("game_ended", self, "_on_Game_game_ended")
