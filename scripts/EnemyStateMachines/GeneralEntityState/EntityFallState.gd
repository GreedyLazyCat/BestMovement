class_name EntityFallState
extends EntityState

@export_group("Sprite Settings")
@export var fall_animation_name: String
@export var fall_land_animation_name: String

func enter():
	state_machine.sprite.play(fall_animation_name)
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)

func update_physics(delta):
	if state_machine.entity.is_on_floor():
		state_machine.sprite.play(fall_land_animation_name)
		state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.35)
		return
	state_machine.entity.velocity.y += state_machine.fall_gravity * delta

func on_anim_finish():
	if state_machine.sprite.animation == fall_land_animation_name:
		transitioned.emit(self, "IdleState")
