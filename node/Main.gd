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
	main_menu_enter()

func main_menu_enter():
	state = GameScene.MainMenu
	var main_menu = main_menu_scene.instace()
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
