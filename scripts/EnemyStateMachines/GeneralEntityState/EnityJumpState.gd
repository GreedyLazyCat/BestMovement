class_name EntityJumpState
extends EntityState

@export var animation_name: String
@export var prep_animation_name: String

func _ready():
	assert(animation_name, "Animation name doenst set")
	assert(prep_animation_name, "Prep animation name doenst set")

func enter():
	state_machine.sprite.play(prep_animation_name)
	state_machine.entity.velocity.x = 0
	if not state_machine.sprite.animation_finished.is_connected(self.on_prep_finished):
		state_machine.sprite.animation_finished.connect(self.on_prep_finished)
	
func on_prep_finished():
	if state_machine.sprite.animation == prep_animation_name:
		state_machine.sprite.play(animation_name)
		state_machine.entity.velocity.y = state_machine.jump_velocity
		state_machine.entity.velocity.x = state_machine.speed

func update_physics(delta):
	if state_machine.sprite.animation == animation_name:
		state_machine.entity.velocity.y += state_machine.jump_gravity * delta
		if state_machine.entity.velocity.y > 0:
			transitioned.emit(self, "FallState")
