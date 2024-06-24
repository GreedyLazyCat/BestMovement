class_name AttackState
extends PlayerState

var ground_combo_animations = ["Attack1", "Attack2", "Attack3"]
var air_combo_animations = ["AirAttack1", "AirAttack2", "AirAttack3"]
var queue: String

@export var hitbox: HitBox
@export var attack_shift: int
@export var block_allow_time: float
@export var block_decrease_amount: float

var block_timer: InCodeTimer

func _ready():
	block_timer = InCodeTimer.new()
	block_timer.timer_step = block_decrease_amount
	block_timer.max_time = block_allow_time
	block_timer.timeout.connect(self.block_allow)

func enter():
	is_h_movement_allowed = false
	is_v_movement_allowed = false
	is_dash_allowed = false
	is_wall_slide_allowed = false
	is_block_allowed = false
	
	block_timer.start()
	
	state_machine.player.velocity.y = 0
	
	hitbox.scale.x = state_machine.player.get_direction()
	if state_machine.player.is_on_floor():
		state_machine.sprite.play(ground_combo_animations[0])
	else:
		state_machine.sprite.play(air_combo_animations[0])
	
	queue = ''
	
	
	#block_current = block_allow_time
	
	hitbox.direction = state_machine.player.get_direction()
	
	
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)

func block_allow():
	if state_machine.current_state == self:
		is_block_allowed = true
		

func update(delta):
	if Input.is_action_just_pressed("attack"):
		if state_machine.sprite.is_playing() and state_machine.sprite.frame > 1:
			queue = get_next_anim(state_machine.sprite.animation)
	
	if state_machine.sprite.is_playing() and \
	(state_machine.sprite.animation in ground_combo_animations \
	or state_machine.sprite.animation in air_combo_animations):
		var frames_len = state_machine.sprite.sprite_frames.get_frame_count(state_machine.sprite.animation)
		
		if state_machine.sprite.frame in range(1, frames_len - 2):
			hitbox.collision_shape.set_deferred("disabled", false)
			state_machine.player.velocity.x = lerp(attack_shift * state_machine.player.get_direction(), 0, 0.35) 
		else:
			hitbox.collision_shape.set_deferred("disabled", true)
			state_machine.player.velocity.x = 0
		if state_machine.sprite.frame > 1:
			is_dash_allowed = true
		else:
			is_dash_allowed = false

func on_anim_finish():
	if state_machine.sprite.animation in air_combo_animations or \
	state_machine.sprite.animation in ground_combo_animations:
		if queue == '':
				if state_machine.player.is_on_floor():
					transitioned.emit(self, "IdleState")
				else:
					transitioned.emit(self, "FallState")
		else:
			state_machine.sprite.play(queue)
			queue = ''

func update_physics(delta):
	block_timer.process_timer(delta)
	state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)


func get_next_anim(anim: String):
	var animations = ground_combo_animations
	
	if not state_machine.player.is_on_floor():
		animations = air_combo_animations
	
	var index = animations.find(anim, 0) + 1
	if index >= len(animations):
		index = 0

	return animations[index]

func exit():
	is_block_allowed = false
	hitbox.collision_shape.set_deferred("disabled", true)
