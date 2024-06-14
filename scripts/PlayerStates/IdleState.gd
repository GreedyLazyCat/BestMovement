class_name IdleState
extends PlayerState

func enter():
	is_h_movement_allowed = true
	state_machine.walk_particles.emitting = false
	state_machine.sprite.play("Idle")
	
func update_physics(delta):
	if not state_machine.player.is_on_floor():
		self.transitioned.emit(self, "FallState")
	state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
