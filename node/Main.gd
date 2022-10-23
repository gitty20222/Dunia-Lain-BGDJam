extends Node

const SAVE_PATH = "user://save"
const main_menu_scene = preload("res://node/MainMenu.tscn")
const game_scene = preload("res://node/Game.tscn")

enum GameScene {
	MainMenu,
	Game
}

var state
var current_scene: Node

func _ready():
	state = GameScene.MainMenu
	main_menu_enter()

func main_menu_enter():
	var main_menu = main_menu_scene.instance()
	main_menu.connect("play_game", self, "_on_Main_Menu_play_game")
	main_menu.connect("reset_game", self, "_on_Main_Menu_reset_game")
	main_menu.connect("exit_game", self, "_on_Main_Menu_exit_game")
	current_scene = main_menu
	add_child(main_menu)

func _on_Main_Menu_exit_game():
	get_tree().quit()

func _on_Main_Menu_reset_game():
	var dir = Directory.new()
	dir.remove(SAVE_PATH)

func _on_Main_Menu_play_game():
	if state != GameScene.MainMenu: return
	state = GameScene.Game
	var main_menu = current_scene
	var game = game_scene.instance()
	current_scene = game
	add_child(game)
	main_menu.queue_free()

func _on_Game_game_ended():
	if state != GameScene.Game: return
	state = GameScene.MainMenu
	var game = current_scene
	main_menu_enter()
	game.queue_free()
