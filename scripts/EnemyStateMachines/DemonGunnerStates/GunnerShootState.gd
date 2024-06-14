class_name GunnerShootState
extends EntityState

@onready var bullet = preload("res://scenes/Entities/GunnerDemon/GunnerBullet.tscn")

func enter():
	state_machine.sprite.play("Shoot")
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)
		state_machine.sprite.frame_changed.connect(self.on_frame_change)

func on_anim_finish():
	if state_machine.sprite.animation == "Shoot" and state_machine.current_state == self:
		if not state_machine.entity.shoot_ray_cast.is_colliding():
			transitioned.emit(self, "IdleState")
		else:
			transitioned.emit(self, "ShootState")

func on_frame_change():
	if state_machine.sprite.frame == 3 and state_machine.sprite.animation == "Shoot":
		var new_bullet = bullet.instantiate() as GunnerBullet
		new_bullet.direction = state_machine.entity.get_direction()
		new_bullet.global_position = state_machine.entity.global_position
		new_bullet.global_position.y += 23
		new_bullet.player = state_machine.player
		get_tree().root.add_child(new_bullet)

func update_physics(delta):
	state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.35)
	

