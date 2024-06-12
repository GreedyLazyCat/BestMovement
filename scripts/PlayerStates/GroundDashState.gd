class_name GroundDashState
extends PlayerState

var prev_velocity
@export var timer: Timer

func enter():
	is_h_movement_allowed = false
	is_v_movement_allowed = false
	state_machine.sprite.play("GroundDash")
	state_machine.player.velocity.y = 0
	if not state_machine.player.is_on_floor():
		state_machine.did_air_dash = true
		state_machine.sprite.play("AirDash")
	prev_velocity = state_machine.player.velocity.x
	state_machine.player.velocity.x = state_machine.dash_force * state_machine.player.get_direction()
	if not timer.timeout.is_connected(self.instantiate_ghost):
		timer.timeout.connect(self.instantiate_ghost)
	
func update_physics(delta):
	if state_machine.sprite.frame > 0:
		is_v_movement_allowed = true
	if not state_machine.sprite.is_playing():
		state_machine.player.velocity.x = prev_velocity
		if not state_machine.player.is_on_floor():
			transitioned.emit(self, state_machine.get_node("FallState"))
		else:
			transitioned.emit(self, state_machine.get_node("RunStopState"))
	else:
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, prev_velocity, 0.2)
		if timer.is_stopped():
			timer.start()

func instantiate_ghost():
	timer.stop()
	var ghost = state_machine.player_ghost.instantiate()
	get_tree().root.add_child(ghost)
	ghost.sprite.global_position = state_machine.player.global_position
	var current_frame_index = state_machine.sprite.frame
	ghost.sprite.texture = state_machine.sprite.sprite_frames.get_frame_texture(state_machine.sprite.animation, current_frame_index)
	ghost.sprite.flip_h = state_machine.sprite.flip_h
	
	
