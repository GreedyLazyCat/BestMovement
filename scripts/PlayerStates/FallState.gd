class_name FallState
extends PlayerState

func enter():
	state_machine.sprite.play("Fall")
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)

func update_physics(delta):
	if state_machine.player.is_on_floor():
		state_machine.sprite.play("FallLand")
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
		return
	state_machine.player.velocity.y += state_machine.fall_gravity * delta

func exit():
	state_machine.did_air_dash = false

func on_anim_finish():
	if state_machine.sprite.animation == "FallLand":
		transitioned.emit(self, "IdleState")
