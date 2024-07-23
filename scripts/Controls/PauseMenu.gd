class_name PauseMenu
extends Control

@onready var animation_player = $AnimationPlayer
@onready var current_button_controller = $CurrentButtonController

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_menu():
	if not paused:
		current_button_controller.process_input = true
		current_button_controller.set_current(0)
		animation_player.play("Pause")
		paused = true

func hide_menu():
	if paused:
		current_button_controller.process_input = false
		paused = false
		animation_player.play("Unpause")

