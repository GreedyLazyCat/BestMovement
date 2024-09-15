class_name FirstLevel
extends Level

@onready var player = $Player
@onready var hound = $Hound
@onready var hound_parts = preload("res://scenes/Entities/Hound/HFirstLevelParts.tscn")
@onready var next_level_area = $NextLevelArea
@onready var tutorial_label = $TutorialLabel

@onready var first_hound = $FirstHound

var tutorial_stage: int = 0

func _ready():
	hound.parts = hound_parts
	next_level_area.body_entered.connect(self.on_player_enter)
	player.movement_handler.moving_allowed = false
	player.movement_handler.jumping_allowed = false
	player.movement_handler.dashing_allowed = false
	player.movement_handler.attacking_allowed= false
	player.movement_handler.blocking_allowed = false

func on_player_enter(body):
	if body is Player:
		transitioned.emit("res://scenes/Levels/AnotherTestLevel.tscn")

func get_player() -> Player:
	return player
	
func _process(delta):
	var new_pos = Vector2(player.global_position.x - 30, player.global_position.y - 30)
	tutorial_label.global_position = new_pos
	
	if tutorial_stage == 0:
		tutorial_label.text = '[A] [D]\nto move'
		var action_strength = Input.get_action_strength("right") - Input.get_action_strength("left")
		if action_strength != 0:
			player.movement_handler.moving_allowed = true
			tutorial_stage += 1
	elif tutorial_stage == 1:
		tutorial_label.text = '[Space]\nto jump'
		player.movement_handler.jumping_allowed = true
		if Input.is_action_just_pressed("jump"):
			tutorial_stage += 1
	elif tutorial_stage == 2:
		tutorial_label.text = ''
		if first_hound.state_machine.player:
			first_hound.state_machine.disable_ai = true
			tutorial_stage += 1
	elif tutorial_stage == 3:
		player.movement_handler.attacking_allowed = true
		tutorial_label.text = '[E] or [Left Mouse]\nto attack'
		if Input.is_action_just_pressed("attack"):
			first_hound.state_machine.disable_ai = false
			tutorial_stage += 1
	elif tutorial_stage == 4:
		tutorial_label.text = '[Ctrl] to block\n[Shift] to dash'
		player.movement_handler.dashing_allowed = true
		player.movement_handler.blocking_allowed = true
		if Input.is_action_just_pressed("dash") or Input.is_action_just_pressed("block"):
			tutorial_stage += 1
	elif tutorial_stage == 5:
		tutorial_label.text = ''
		
