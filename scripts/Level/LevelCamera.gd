class_name LevelCamera
extends Camera2D

@export var hud: Hud
@export var anim_player: AnimationPlayer
@export var pause_menu: PauseMenu
@onready var death_screen: DeathScreen = $CRTEffect/DeathScreen
@onready var canvas_layer: CanvasLayer = $CRTEffect

var controls: Array[Control]
var active_control: Control

var paused = false
var pause_allowed = true

func _ready():
	for child in canvas_layer.get_children():
		if child is Control:
			controls.append(child as Control)

func update_controls_list():
	controls.clear()
	for child in canvas_layer.get_children():
		if child is Control:
			controls.append(child as Control)

func disable_mouse_input_except(control: Control):
	update_controls_list()
	active_control = control
	for to_disable in controls:
		if to_disable == control:
			to_disable.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
			continue
		to_disable.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])

func hide_current_control():
	if active_control is PauseMenu:
		hide_pause_menu()
	elif active_control is DeathScreen:
		hide_death_screen()

func show_death_screen():
	death_screen.show_screen()
	disable_mouse_input_except(death_screen)

func hide_death_screen():
	death_screen.hide_screen()
	death_screen.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])
	

func show_pause_menu():
	pause_menu.show_menu()
	disable_mouse_input_except(pause_menu)
	#pause_menu.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_STOP])
	

func hide_pause_menu():
	pause_menu.hide_menu()
	pause_menu.propagate_call("set_mouse_filter", [Control.MOUSE_FILTER_IGNORE])

func play_transition(anim_name: String):
	anim_player.play(anim_name)
	
func unpause():
	paused = false
	get_tree().paused = false
	
func _process(delta):
	if Input.is_action_just_pressed("pause") and pause_allowed:
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
