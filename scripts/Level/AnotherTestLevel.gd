class_name AnotherTestLevel
extends Level

@onready var player: Player = $Player
@onready var stopwatch: StopWatch = $StopWatch

func get_player():
	return player

func get_stopwatch():
	return stopwatch


func _on_level_condition_checker_all_conditions_done():
	get_stopwatch().stop()
