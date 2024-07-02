class_name EntryPoint
extends Node2D

@onready var level_container = $LevelContainer
@export var camera: LevelCamera

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
	
			

func handle_loading_level():
	if loading_level:
		var status = ResourceLoader.load_threaded_get_status(level_path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_level = ResourceLoader.load_threaded_get(level_path).instantiate() as Level
			
			if not level.get_player():
				remove_child(camera)
			else:
				level.remove_child(camera)
			
			level_container.remove_child(level)
			level_container.add_child(new_level)
			
			attach_camera(new_level)
			level.queue_free()
			
			level = new_level
			connect_level_ui(level)
			camera.play_transition("OutTransition")
			loading_level = false
		elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			loading_level = false
			print("Invalid resource")
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			loading_level = false
			print("Load failed")

func attach_camera(to_level: Level):
	if not to_level.get_player():
		var size = get_viewport_rect().size
		camera.global_position = Vector2(size.x / 2, size.y / 2)
		camera.zoom = Vector2(1.0, 1.0)
		camera.hud.visible = false
	else:
		to_level.get_player().add_child(camera)
		to_level.get_player().camera = camera
		camera.global_position = to_level.get_player().global_position
		camera.reset_smoothing()
		camera.hud.connect_player(to_level.get_player())
		camera.hud.visible = true
		camera.zoom = Vector2(3.0, 3.0)
		
		


func _on_transition_finished(anim_name):
	if anim_name == "InTransition":
		loading_level = true


func _on_play_button_pressed():
	pass # Replace with function body.
