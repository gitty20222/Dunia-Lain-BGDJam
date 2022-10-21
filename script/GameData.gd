extends Object
class_name GameData

var statuses: Array
var events: Array
	
func _init(dir: String):
	self.events = get_choice_list_from_dir(dir + "events/")
	self.statuses = get_status_list_from_dir(dir + "status/")

func get_choice_list_from_dir(dir: String) -> Array:
	var files = list_files_in_directory(dir)
	var events := []
	for file in files:
		if !(file.ends_with(".tres") or file.ends_with(".res")):
			continue
		events.append(ResourceLoader.load(dir + file)) 
	return events

func get_status_list_from_dir(dir: String) -> Array:
	var files = list_files_in_directory(dir)
	var statuses := []
	for file in files:
		if !(file.ends_with(".tres") or file.ends_with(".res")):
			continue
		statuses.append(ResourceLoader.load(dir + file)) 
	return statuses

func list_files_in_directory(path) -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	return files
