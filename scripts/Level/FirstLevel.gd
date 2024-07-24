class_name FirstLevel
extends Level

@onready var player = $Player
@onready var hound = $Hound
@onready var hound_parts = preload("res://scenes/Entities/Hound/HFirstLevelParts.tscn")

func _ready():
	hound.parts = hound_parts

func get_player() -> Player:
	return player

