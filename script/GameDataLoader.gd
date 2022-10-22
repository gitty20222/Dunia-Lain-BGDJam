extends Object
class_name GameDataLoader

static func load_events_from(dir: String) -> Array:
	return _get_choice_list_from_dir(dir)

static func load_status_from(dir: String) -> Array:
	return _get_status_list_from_dir(dir)

static func _get_choice_list_from_dir(dir: String) -> Array:
	var files = list_files_in_directory(dir)
	var events := []
	for file in files:
		if !(file.ends_with(".tres") or file.ends_with(".res")):
			continue
		events.append(ResourceLoader.load(dir + file)) 
	return events

static func _get_status_list_from_dir(dir: String) -> Array:
	var files = list_files_in_directory(dir)
	var statuses := []
	for file in files:
		if !(file.ends_with(".tres") or file.ends_with(".res")):
			continue
		statuses.append(ResourceLoader.load(dir + file)) 
	return statuses

static func list_files_in_directory(path) -> Array:
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
