enum Ending {
	Healthy,
	Happy,
	Rich,
	GameOver_Died,
	GameOver_Depressed,
	GameOver_Destitute,
	EVENT_POOL_INSUFFICIENT
}

enum EventStatus {
	Accepted,
	Declined,
	Unresolved
}

enum Priority {
	Low = 0,
	Medium = 1,
	High = 2
}

static func str_short_priority(priority_enum) -> String:
	match priority_enum:
		Priority.Low:
			return "low"
		Priority.Medium:
			return "med"
		Priority.High:
			return "high"
		_:
			return ""

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
