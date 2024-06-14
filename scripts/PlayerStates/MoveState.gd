class_name MoveState
extends PlayerState

func enter():
	self.is_h_movement_allowed = true
	state_machine.walk_particles.emitting = true
	state_machine.sprite.play("Run")

func update_physics(delta):
	if not state_machine.player.is_on_floor():
		transitioned.emit(self, "FallState")
