class_name EntryPoint
extends Node2D

@onready var level_container = $LevelContainer
@export var camera: LevelCamera

@export var MAIN_MENU_PATH: String

var level: Level
var paused: bool = false

var loading_level: bool = false
var level_path: String
var level_ui: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if not level_container.get_child_count() == 0:
		var child = level_container.get_child(0)
		if child is Level:
			level = level_container.get_child(0) as Level
			level.transitioned.connect(self.on_level_change)
			attach_camera(level)
			connect_level_ui(level)
		
	#camera.anim_player.animation_finished.connect(self.on_transition_finished)



func connect_level_ui(to_level: Level):
	if level_ui:
		level_ui.queue_free()
	level_ui = to_level.get_level_ui()
	if level_ui:
		level_ui.reparent(camera.canvas_layer)
		var count = camera.canvas_layer.get_child_count()
		camera.canvas_layer.move_child(level_ui, count - 3)

func on_level_change(path: String):
	ResourceLoader.load_threaded_request(path)
	level_path = path
	camera.play_transition("InTransition")
	level.play_transition("InTransition")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_loading_level()
	if Input.is_action_just_pressed("reload"):
		on_level_change(level_path)
	
			

func handle_loading_level():
	if loading_level:
		var status = ResourceLoader.load_threaded_get_status(level_path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_level = ResourceLoader.load_threaded_get(level_path).instantiate() as Level
			
			#if not level.get_player():
				#remove_child(camera)
			#elif level != new_level:
				#level.get_player().remove_child(camera)
			
			level_container.remove_child(level)
			level_container.add_child(new_level)
			
			attach_camera(new_level)
			level.queue_free()
			
			level = new_level
			level.transitioned.connect(self.on_level_change)
			if level.get_player():
				level.get_player().health_handler.dead.connect(self.on_player_death)
			connect_level_ui(level)
			camera.call_deferred("update_controls_list")
			camera.play_transition("OutTransition")
			loading_level = false
		elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading_level = false
			print("Invalid resource")
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			loading_level = false
			print("Load failed")

func attach_camera(to_level: Level):
	camera.limit_left = to_level.camera_limit_left
	camera.limit_right = to_level.camera_limit_right
	if not to_level.get_player():
		camera.reparent(self)
		move_child(camera, 0)
		var size = get_viewport_rect().size
		camera.global_position = Vector2(size.x / 2, size.y / 2)
		camera.zoom = Vector2(1.0, 1.0)
		camera.hud.visible = false
		if to_level is MainMenu:
			camera.pause_allowed = false
	else:
		if camera.get_parent():
			camera.reparent(to_level.get_player())
		else:
			to_level.get_player().add_child(camera)
		camera.pause_allowed = true
		to_level.get_player().camera = camera
		camera.global_position = to_level.get_player().global_position
		camera.reset_smoothing()
		
		camera.hud.connect_player(to_level.get_player())
		camera.hud.connect_stopwatch(to_level.get_stopwatch())
		camera.hud.visible = true
		
		camera.zoom = Vector2(3.0, 3.0)
		
		

func on_player_death():
	if not camera.anim_player.current_animation == "InTransition" \
	and not camera.anim_player.is_playing():
		camera.show_death_screen()
		if level.get_stopwatch():
			level.get_stopwatch().stop()
		camera.pause_allowed = false

func _on_transition_finished(anim_name):
	if anim_name == "InTransition":
		loading_level = true
	if anim_name == "OutTransition":
		if level.get_stopwatch():
			level.get_stopwatch().start()


func _on_play_button_pressed():
	pass # Replace with function body.

func _on_reload_level_pressed():
	if camera.active_control is PauseMenu:
		camera.hide_pause_menu()
		camera.unpause()
		on_level_change(level_path)
	elif camera.active_control is DeathScreen:
		camera.hide_death_screen()
		camera.unpause()
		on_level_change(level_path)


func _on_quit_to_main_menu_pressed():
	camera.hide_current_control()
	camera.unpause()
	camera.hud.visible = false
	camera.hud.disconnect_player()
	camera.hud.disconnect_stopwatch()
	on_level_change(MAIN_MENU_PATH)
