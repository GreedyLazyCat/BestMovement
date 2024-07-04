class_name Level
extends Node2D
@export_group("Level Camera Settings")
@export var camera_limit_left: int = -10000000
@export var camera_limit_right: int = 10000000

signal transitioned(path: String)

func get_level_ui() -> Control:
	return null

func get_player() -> Player:
	return null

func play_transition(transition_name: String):
	pass

