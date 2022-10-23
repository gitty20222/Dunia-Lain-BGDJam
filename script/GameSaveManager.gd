extends Node

func write_save(path: String, data: GameStateData) -> void:
	ResourceSaver.save(path, data)
	
# Tries to load game state data from the path and return it.
# In case of error, return 
func read_save(path: String):
	ResourceLoader.load(path, "GameStateData", true)
	
