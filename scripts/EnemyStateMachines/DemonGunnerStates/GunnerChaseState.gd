class_name GunnerChaseState
extends GunnerState

func enter():
	state_machine.sprite.play("Run")
	
func update_physics(delta):
	if state_machine.player:
		var direction = state_machine.entity.global_position.direction_to(state_machine.player.global_position)
		state_machine.entity.velocity.x = state_machine.speed * sign(direction.x)
	if not state_machine.entity.is_on_floor():
		transitioned.emit(self, state_machine.get_node("GunnerFallState"))
	
