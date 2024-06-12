class_name AirDashState
extends State

var prev_velocity

func enter():
	state_machine.sprite.play("GroundDash")
	if not state_machine.player.is_on_floor():
		state_machine.player.velocity.y = 0
		state_machine.did_air_dash = true
		state_machine.sprite.play("AirDash")
	prev_velocity = state_machine.player.velocity.x
	state_machine.player.velocity.x = state_machine.dash_force * state_machine.player.get_direction()
	
	
func update_physics(delta):
	if not state_machine.sprite.is_playing():
		state_machine.player.velocity.x = prev_velocity
		if not state_machine.player.is_on_floor():
			transitioned.emit(self, state_machine.get_node("FallState"))
		else:
			state_machine.change_to_prev_state()
	else:
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, prev_velocity, 0.2)
		instantiate_ghost()
		
func instantiate_ghost():
	var ghost = state_machine.player_ghost.instantiate()
	get_tree().root.add_child(ghost)
	ghost.global_position = state_machine.player.global_position
	var current_frame_index = state_machine.sprite.frame
	ghost.texture = state_machine.sprite.sprite_frames.get_frame_texture(state_machine.sprite.animation, current_frame_index)
