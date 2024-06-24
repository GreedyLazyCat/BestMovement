extends Node2D

@onready var vhs_layer = $Player/Camera2D/CameraEffect/ColorRect
@onready var animation_player = $AnimationPlayer
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("kill"):
		player.health_handler.deal_damage(2000)
	if Input.is_action_just_pressed("dash_unkill"):
		player.invinsible_dash = not player.invinsible_dash
	if Input.is_action_just_pressed("debug_slowmo"):
		Engine.time_scale = 0.1
	if Input.is_action_just_released("debug_slowmo"):
		Engine.time_scale = 1
