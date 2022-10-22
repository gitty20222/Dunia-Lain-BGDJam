extends Object
class_name ArrayExt

# Returns true if all elements of the array match value
static func for_all(arr: Array, value) -> bool:
	for e in arr:
		if e != value:
			return false
	return true
