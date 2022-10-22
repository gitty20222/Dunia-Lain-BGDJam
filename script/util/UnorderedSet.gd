extends Object
class_name UnorderedSet

var _dict: Dictionary

func _init():
	_dict = {}

func add(key):
	if not _dict.has(key):
		_dict[key] = null
		
func remove(key):
	if _dict.has(key):
		_dict.erase(key)
		
func contains(key):
	return _dict.has(key)
