class_name RunStopState
extends PlayerState

func enter():
	state_machine.sprite.play("RunStop")

func update_physics(delta):
	if not state_machine.player.is_on_floor():
		self.transitioned.emit(self, state_machine.get_node("FallState"))
	if not state_machine.sprite.is_playing():
		transitioned.emit(self, state_machine.get_node("IdleState"))
	state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
