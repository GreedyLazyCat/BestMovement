class_name HoundAttackState
extends HoundState

@export var hitbox: HitBox
@export var animation_name: String
var sprite: AnimatedSprite2D

func _ready():
	assert(hitbox, "HitBox not attached")

func enter():
	if not sprite:
		sprite = get_state_machine().sprite
	sprite.play(animation_name)
	if not sprite.animation_finished.is_connected(self.on_anim_finish):
		sprite.animation_finished.connect(self.on_anim_finish)
	if not sprite.frame_changed.is_connected(self.on_frame_changed):
		sprite.frame_changed.connect(self.on_frame_changed)

func on_frame_changed():
	if sprite.animation == animation_name:
		if sprite.frame in range(3, 5):
			hitbox.collision_shape.set_deferred("disabled", false)
		else:
			hitbox.collision_shape.set_deferred("disabled", true)
	

func on_anim_finish():
	if sprite.animation == animation_name:
		if get_state_machine().entity.attack_ray_cast.is_colliding():
			transitioned.emit(self, "AttackState")
		else:
			transitioned.emit(self, "ChaseState")

func update_physics(delta):
	var entity = get_state_machine().entity
	entity.velocity.x = lerp(entity.velocity.x, 0.0, 0.35)
