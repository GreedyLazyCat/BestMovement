class_name BlockState
extends PlayerState

func enter():
	is_h_movement_allowed = false
	state_machine.sprite.play("Block")
	state_machine.walk_particles.emitting = false

func update_physics(delta):
	if not state_machine.player.is_on_floor():
		self.transitioned.emit(self, "FallState")
	state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
