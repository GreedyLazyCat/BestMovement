extends Control

@onready var animation_player = $AnimationPlayer

var start_level = "res://scenes/TestLevel.tscn"
var start_load_level = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_load_level:
		var status = ResourceLoader.load_threaded_get_status(start_level)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var new_scene = ResourceLoader.load_threaded_get(start_level)
			get_tree().change_scene_to_packed(new_scene)
		

func _on_button_pressed():
	animation_player.play("StartGame")
	ResourceLoader.load_threaded_request(start_level)
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "StartGame":
		start_load_level = true


func _on_quit_pressed():
	get_tree().quit()
