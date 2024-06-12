extends Node2D

@onready var vhs_layer = $Player/Camera2D/CanvasLayer2/ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Test")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
