class_name MainMenu
extends Level

@onready var animation_player = $AnimationPlayer
@onready var level_ui = $CanvasLayer/LevelUI
@onready var title = $CanvasLayer/LevelUI/Label
@onready var buttons = $CanvasLayer/LevelUI/VBoxContainer
@onready var play_button = $CanvasLayer/LevelUI/VBoxContainer/PlayButton/Button
@onready var current_button_controller = $CurrentButtonController

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.pressed.connect(self._on_button_pressed)
	current_button_controller.process_input = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_level_ui():
	return level_ui

func play_transition(transition_name: String):
	if animation_player.has_animation(transition_name):
		animation_player.play(transition_name)
	if transition_name == "InTransition":
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(title, "global_position", Vector2(title.global_position.x, title.global_position.y - 180), 0.5)
		tween.parallel().tween_property(buttons, "global_position", Vector2(buttons.global_position.x, buttons.global_position.y + 800), 0.8)

func _on_play_button_pressed():
	pass


func _on_button_pressed():
	transitioned.emit("res://scenes/Levels/FirstLevel.tscn")


func _on_quit_pressed():
	get_tree().quit()
