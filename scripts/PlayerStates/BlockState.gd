class_name BlockState
extends PlayerState

@export var hurtbox: HurtBox
#@export var 

func enter():
	hurtbox.set_deferred("is_blocking", true)
	is_h_movement_allowed = false
	is_attack_allowed = false
	state_machine.player.velocity.x = state_machine.player.velocity.x * 0.25
	if not state_machine.player.is_on_floor():
		state_machine.sprite.play("AirBlock")
		is_v_movement_allowed = false
		
	else:
		state_machine.sprite.play("Block")
	state_machine.walk_particles.emitting = false

func get_gravity():
	if state_machine.player.velocity.y < 0:
		return state_machine.fall_gravity
	return state_machine.jump_gravity

func update_physics(delta):
	if not state_machine.player.is_on_floor():
		state_machine.player.velocity.y += get_gravity() * delta * 0.5
	elif not state_machine.sprite.animation == "Knockback":
		state_machine.sprite.play("Block")
	if state_machine.player.is_on_floor():
		is_v_movement_allowed = true
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)

func exit():
	hurtbox.set_deferred("is_blocking", false)
