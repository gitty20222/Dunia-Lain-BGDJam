enum Ending {
	Healthy,
	Happy,
	Rich,
	GameOver_Died,
	GameOver_Depressed,
	GameOver_Destitute
}

enum EventStatus {
	Accepted,
	Declined,
	Unresolved
}

static func str_ending(ending_enum) -> String:
	match ending_enum:
		Ending.Healthy:
			return "Healthy"
		Ending.Happy:
			return "Happy"
		Ending.Rich:
			return "Rich"
		Ending.GameOver_Died:
			return "GameOver_Died"
		Ending.GameOver_Depressed:
			return "GameOver_Depressed"
		Ending.GameOver_Destitute:
			return "GameOver_Destitute"
		_:
			return ""
