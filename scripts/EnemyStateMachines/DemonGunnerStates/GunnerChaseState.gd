class_name GunnerChaseState
extends EntityState

@export var stop_chase_margin: int = 10
@export var runaway_distance: int = 20

var runaway_mode: bool = false

func enter():
	state_machine.sprite.play("Run")
	
func update_physics(delta):
	if state_machine.player:
		var direction = state_machine.entity.global_position.direction_to(state_machine.player.global_position)
		var distance = abs(state_machine.player.global_position.x - state_machine.entity.global_position.x)
		if not runaway_mode:
			if distance > runaway_distance:
				state_machine.entity.velocity.x = state_machine.speed * sign(direction.x)
			else:
				runaway_mode = true
		else:
			if distance < runaway_distance + stop_chase_margin:
				state_machine.entity.velocity.x = state_machine.speed * sign(direction.x) * -1
			else:
				runaway_mode = false
	if not state_machine.entity.is_on_floor():
		transitioned.emit(self, "FallState")
	
