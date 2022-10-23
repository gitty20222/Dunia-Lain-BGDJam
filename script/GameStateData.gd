extends Resource
class_name GameStateData

export(int) var turn_number: int

# Stats
export(float) var health: float
export(float) var happiness: float
export(float) var money: float

# Aspect Values
export(float) var fitness_value: float
export(float) var work_value: float
export(float) var social_value: float
export(float) var sleep_value: float

# Tag and Status State
export(Dictionary) var event_tag_set: Dictionary #(Dictionary of tags [set])
export(Dictionary) var active_statuses: Dictionary # Dictionary(status_id, time_remaining(int))

# Event State
export(int) var n_events_this_turn: int
export(Array, String) var active_events: Array # Array (Event Id)

# History
export(Array, String) var event_history: Array # Array (Event Id)

func _init(game_state):
	self.turn_number = game_state.turn_number
	
	self.health = game_state.health
	self.happiness = game_state.happiness
	self.money = game_state.money
	
	self.fitness_value = game_state.fitness_value
	self.work_value = game_state.work_value
	self.social_value = game_state.social_value
	self.sleep_value = game_state.sleep_value
	
	self.event_tag_set = game_state.event_tag_set
	self.active_statuses = game_state.active_statuses
	
	self.n_events_this_turn = game_state.n_events_this_turn
	self.active_events = game_state.active_events
	self.event_history = game_state.event_history
