class_name JumpState
extends PlayerState


func enter():
	state_machine.sprite.play("Jump")
	state_machine.player.velocity.y = state_machine.jump_velocity
	if state_machine.prev_state == state_machine.get_node("GroundDashState"):
		state_machine.player.velocity.x = state_machine.speed

func update_physics(delta):
	state_machine.player.velocity.y += state_machine.jump_gravity * delta
	if state_machine.player.velocity.y > 0:
		transitioned.emit(self, state_machine.get_node("FallState"))
