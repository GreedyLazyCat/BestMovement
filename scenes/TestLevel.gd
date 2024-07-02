extends Level

@onready var vhs_layer = $Player/Camera2D/CameraEffect/CRT1
@onready var animation_player = $AnimationPlayer
@onready var death_screen = $Player/Camera2D/CanvasLayer2/DeathScreen
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_handler.dead.connect(self.on_death)
	death_screen.restart_button.pressed.connect(self.on_restart_press)
	
func on_death():
	death_screen.show_screen()
	animation_player.play("NoiseScreen")
	
func on_restart_press():
	get_tree().reload_current_scene()


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


func _on_level_condition_checker_all_conditions_done():
	print("All conditions done")
