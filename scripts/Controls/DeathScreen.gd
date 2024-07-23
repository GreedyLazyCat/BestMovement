class_name DeathScreen
extends Control


@onready var animation_player = $AnimationPlayer
@onready var restart_button = $VBoxContainer/RestartButton/Button
@onready var quit_menu_button = $VBoxContainer/QuitToMenuButton/Button
@onready var current_button_controller = $CurrentButtonController

func show_screen():
	current_button_controller.process_input = true
	current_button_controller.set_current(0)
	animation_player.play("Show")

func hide_screen():
	current_button_controller.process_input = false
	animation_player.play("Hide")
	 
