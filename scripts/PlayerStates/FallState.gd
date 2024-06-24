class_name FallState
extends PlayerState

@export var coyote_time: float = 0.1

func enter():
	state_machine.walk_particles.emitting = false
	is_v_movement_allowed = false
	if state_machine.prev_state_is("WallSlide") or state_machine.prev_state_is("MoveState"):
		is_v_movement_allowed = true
		get_tree().create_timer(coyote_time).timeout.connect(self.disable_v_movement)
	
	#is_block_allowed = false
	state_machine.sprite.play("Fall")
	
	if not state_machine.sprite.animation_finished.is_connected(self.on_anim_finish):
		state_machine.sprite.animation_finished.connect(self.on_anim_finish)
	

func disable_v_movement():
	is_v_movement_allowed = false

func update_physics(delta):
	if state_machine.player.is_on_floor():
		state_machine.sprite.play("FallLand")
		state_machine.player.velocity.x = lerp(state_machine.player.velocity.x, 0.0, 0.35)
		return
	state_machine.player.velocity.y += state_machine.fall_gravity * delta

func exit():
	state_machine.did_air_dash = false

func on_anim_finish():
	if state_machine.sprite.animation == "FallLand":
		transitioned.emit(self, "IdleState")
