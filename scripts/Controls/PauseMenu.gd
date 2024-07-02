class_name PauseMenu
extends Control

@onready var animation_player = $AnimationPlayer

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_menu():
	if not paused:
		animation_player.play("Pause")
		paused = true
func hide_menu():
	if paused:
		paused = false
		animation_player.play("Unpause")

