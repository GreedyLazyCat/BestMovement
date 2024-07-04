class_name AnotherTestLevel
extends Level

@onready var player: Player = $Player

func get_player():
	return player


func _on_level_condition_checker_all_conditions_done():
	print("Win")
