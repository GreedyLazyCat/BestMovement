class_name JumpState
extends PlayerState


func enter():
	is_v_movement_allowed = false
	is_block_allowed = false
	is_h_movement_allowed = true
	state_machine.sprite.play("Jump")
	state_machine.player.velocity.y = state_machine.jump_velocity
	if state_machine.prev_state == state_machine.get_node("GroundDashState"):
		state_machine.player.velocity.x = state_machine.speed

func update_physics(delta):
	state_machine.player.velocity.y += state_machine.jump_gravity * delta
	if state_machine.player.velocity.y > 0:
		transitioned.emit(self, "FallState")
