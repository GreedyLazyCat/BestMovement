class_name LevelCamera
extends Camera2D

@export var hud: Hud
@export var anim_player: AnimationPlayer
@export var pause_menu: PauseMenu
@export var canvas_layer: CanvasLayer

var paused = false

func show_pause_menu():
	pause_menu.show_menu()
	pause_menu.mouse_filter = Control.MOUSE_FILTER_STOP

func hide_pause_menu():
	pause_menu.hide_menu()
	pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE

func play_transition(anim_name: String):
	anim_player.play(anim_name)
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if paused:
			hide_pause_menu()
			paused = false
			get_tree().paused = false
		else:
			var level = get_tree().root.get_node("EntryPoint").get_node("LevelContainer").get_child(0)
			
			if not level is MainMenu:
				show_pause_menu()
				paused = true
				get_tree().paused = true
