class_name Level
extends Node2D


signal transitioned(path: String)

func get_level_ui() -> Control:
	return null

func get_player() -> Player:
	return null

func play_transition(transition_name: String):
	pass
