class_name BlockState
extends PlayerState

@export var hurtbox: HurtBox

func _ready():
	hurtbox.hurted.connect(self.on_hit)

func on_hit(hitbox: HitBox):
	if state_machine.current_state == self:
		state_machine.player.velocity.x = state_machine.speed * hitbox.direction
		print(hitbox.direction)
		state_machine.sprite.play("Knockback")

func enter():
	
	is_h_movement_allowed = false
	state_machine.player.velocity.x = state_machine.player.velocity.x * 0.25
	if not state_machine.player.is_on_floor():
		state_machine.sprite.play("AirBlock")
	else:
		state_machine.sprite.play("Block")
	state_machine.walk_particles.emitting = false

func get_gravity():
	if state_machine.player.velocity.y < 0:
		return state_machine.fall_gravity
	return state_machine.jump_gravity

func update_physics(delta):
	if state_machine.sprite.animation == "Knockback" and not state_machine.sprite.is_playing():
		transitioned.emit(self, "IdleState")
	if not state_machine.player.is_on_floor():
		state_machine.player.velocity.y += get_gravity() * delta * 0.5
	elif not state_machine.sprite.animation == "Knockback":
		state_machine.sprite.play("Block")
	if state_machine.player.is_on_floor():
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
