class_name GunnerJumpState
extends GunnerState

func enter():
	state_machine.sprite.play("JumpPrep")
	state_machine.entity.velocity.x = 0
	if not state_machine.sprite.animation_finished.is_connected(self.on_prep_finished):
		state_machine.sprite.animation_finished.connect(self.on_prep_finished)
	
func on_prep_finished():
	if state_machine.sprite.animation == "JumpPrep":
		state_machine.sprite.play("Jump")
		state_machine.entity.velocity.y = state_machine.jump_velocity
		state_machine.entity.velocity.x = state_machine.speed

func update_physics(delta):
	if state_machine.sprite.animation == "Jump":
		state_machine.entity.velocity.y += state_machine.jump_gravity * delta
		if state_machine.entity.velocity.y > 0:
			transitioned.emit(self, state_machine.get_node("GunnerFallState"))
