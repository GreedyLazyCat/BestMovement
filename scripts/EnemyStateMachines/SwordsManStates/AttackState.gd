class_name SwordsManAttackState
extends SwordsManState

var attack_phase: bool = true
@export var hitbox: HitBox
@export var stab_speed_multiply: float
@export var stab_damage: int = 1
@export var leap_damage: int = 2

func _ready():
	assert(hitbox, "HitBox is not connected")

func enter():
	state_machine.entity.velocity.x = 0
	if attack_phase:
		hitbox.set_deferred("damage", stab_damage)
		state_machine.sprite.play("ChargeStab")
	else:
		hitbox.set_deferred("damage", leap_damage)
		state_machine.sprite.play("LeapPrep")
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)
	if not state_machine.sprite.frame_changed.is_connected(self.on_frame_change):
		state_machine.sprite.frame_changed.connect(self.on_frame_change)
		

func on_frame_change():
	if state_machine.sprite.animation == "ChargeStab":
		if state_machine.sprite.frame in range(7, 11):
			hitbox.set_deferred("direction", state_machine.get_direction(state_machine.entity))
			hitbox.collision_shape.set_deferred("disabled", false)
		elif state_machine.sprite.frame in range(11, 14):
			hitbox.collision_shape.set_deferred("disabled", true)

func on_anim_finish():
	if state_machine.sprite.animation == "LeapPrep":
		state_machine.sprite.play("LeapJump")
		hitbox.set_deferred("direction", state_machine.get_direction(state_machine.entity))
		
		hitbox.collision_shape.set_deferred("disabled", false)
		var distance = abs(state_machine.player.global_position.x - state_machine.entity.global_position.x)
		var speed = distance / (state_machine.jump_time_to_descent + state_machine.jump_time_to_peak)
		state_machine.entity.velocity.x = speed * state_machine.get_direction(state_machine.entity)
		state_machine.entity.velocity.y = state_machine.jump_velocity
	elif state_machine.sprite.animation == "LeapLand":
		next_attack_phase()
		transitioned.emit(self, "IdleState")
		hitbox.collision_shape.set_deferred("disabled", true)
	elif state_machine.sprite.animation == "ChargeStab":
		next_attack_phase()
		if state_machine.entity.is_on_floor():
			transitioned.emit(self, "FallState")
		else:
			transitioned.emit(self, "IdleState")
			

func next_attack_phase():
	attack_phase = not attack_phase

func get_gravity():
	if state_machine.entity.velocity.y < 0:
		state_machine.sprite.play("LeapFall")
		return state_machine.fall_gravity
	return state_machine.jump_gravity

func update_physics(delta):
	state_machine.entity.velocity.y += get_gravity() * delta
	if state_machine.entity.is_on_floor() and state_machine.sprite.animation == "LeapFall":
		state_machine.entity.velocity.x = 0
		state_machine.sprite.play("LeapLand")
	if state_machine.sprite.animation == "ChargeStab":
		if state_machine.sprite.frame in range(7, 11):
				state_machine.entity.velocity.x = state_machine.speed * stab_speed_multiply\
				 * state_machine.get_direction(state_machine.entity)
		elif state_machine.sprite.frame in range(11, 14):
			state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.2)
