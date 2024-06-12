class_name GunnerFallState
extends GunnerState



func enter():
	state_machine.sprite.play("Fall")
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)

func update_physics(delta):
	if state_machine.entity.is_on_floor():
		state_machine.sprite.play("FallLand")
		state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.35)
		return
	state_machine.entity.velocity.y += state_machine.fall_gravity * delta

func on_anim_finish():
	if state_machine.sprite.animation == "FallLand":
		transitioned.emit(self, state_machine.get_node("GunnerIdleState"))
