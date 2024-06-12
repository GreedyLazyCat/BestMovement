class_name GunnerShootState
extends GunnerState

func enter():
	state_machine.sprite.play("Shoot")
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)

func on_anim_finish():
	
	if state_machine.sprite.animation == "Shoot":
		if not state_machine.entity.shoot_ray_cast.is_colliding():
			transitioned.emit(self, state_machine.get_node("GunnerIdleState"))
		else:
			transitioned.emit(self, state_machine.get_node("GunnerShootState"))

func update_physics(delta):
	state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.35)


