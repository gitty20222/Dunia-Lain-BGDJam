extends Node

func write_save(path: String, data: GameStateData) -> void:
	ResourceSaver.save(path, data)
	
# Tries to load game state data from the path and return it.
func read_save(path: String):
	return ResourceLoader.load(path)
	
