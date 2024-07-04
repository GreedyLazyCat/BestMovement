class_name DeathScreen
extends Control


@onready var animation_player = $AnimationPlayer
@onready var restart_button = $VBoxContainer/RestartButton/Button
@onready var quit_menu_button = $VBoxContainer/QuitToMenuButton/Button

func show_screen():
	animation_player.play("Show")

func hide_screen():
	animation_player.play("Hide")
	 
