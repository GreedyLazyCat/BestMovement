class_name MainMenu
extends Level

@onready var animation_player = $AnimationPlayer
@onready var level_ui = $CanvasLayer/LevelUI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_level_ui():
	return level_ui

func play_transition(transition_name: String):
	if animation_player.has_animation(transition_name):
		animation_player.play(transition_name)

func _on_play_button_pressed():
	pass


func _on_button_pressed():
	transitioned.emit("res://scenes/Levels/AnotherTestLevel.tscn")
