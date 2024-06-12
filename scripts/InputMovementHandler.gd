class_name InputMovementHandler
extends Node

@export var state_machine: StateMachine
@export var ray_cast: RayCast2D

var current_speed: float

var jump_buffered: bool = false


func _physics_process(delta):
	var no_movement_action_pressed = true
	
	if Input.is_action_pressed("left"):
		no_movement_action_pressed = false
		if state_machine.current_state.is_h_movement_allowed:
			if state_machine.player.is_on_floor():
				state_machine.change_state_to("MoveState")
			
				current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
				state_machine.player.velocity.x = -current_speed
	
	if Input.is_action_pressed("right"):
		no_movement_action_pressed = false
		if state_machine.current_state.is_h_movement_allowed:
			if state_machine.player.is_on_floor():
				state_machine.change_state_to("MoveState")
			
			current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
			state_machine.player.velocity.x = current_speed
	
	if Input.is_action_just_pressed("jump"):
		if state_machine.current_state.is_v_movement_allowed:
			if is_able_to_jump():
				state_machine.change_state_to("JumpState")
			else:
				if ray_cast.is_colliding() and not state_machine.player.is_on_floor():
					jump_buffered = true
	
	if Input.is_action_just_pressed("dash"):
		if state_machine.current_state.is_dash_allowed:
			if not state_machine.player.is_on_floor():
				if not state_machine.did_air_dash:
					state_machine.change_state_to("GroundDashState")
			else:
				state_machine.change_state_to("GroundDashState")
		
	if Input.is_action_just_pressed("attack"):
		if state_machine.current_state.is_attack_allowed:
			state_machine.change_state_to("AttackState")
	
	if no_movement_action_pressed and state_machine.current_state_is("MoveState"):
		current_speed = 0
		state_machine.change_state_to("RunStopState")
	
	if jump_buffered:
		if is_able_to_jump():
			jump_buffered = !jump_buffered
			state_machine.change_state_to("JumpState")


func is_able_to_jump() -> bool:
	return state_machine.player.is_on_floor()

