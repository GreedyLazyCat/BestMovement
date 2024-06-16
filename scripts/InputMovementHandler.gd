class_name InputMovementHandler
extends Node

@export var state_machine: StateMachine
@export var jump_ray_cast: RayCast2D
@export var wall_slide_ray_cast: RayCast2D

var current_speed: float

var jump_buffered: bool = false
var can_use_block: bool = true

func _physics_process(delta):
	if jump_buffered and state_machine.player.is_on_floor():
		jump_buffered = false
		state_machine.change_state_to("JumpState")
	
	if Input.is_action_pressed("left"):
		if state_machine.current_state.is_h_movement_allowed:
			current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
			state_machine.player.velocity.x = -current_speed
			
			if state_machine.player.is_on_floor():
				state_machine.change_state_to("MoveState")
				
	if Input.is_action_pressed("right"):
		if state_machine.current_state.is_h_movement_allowed:
			current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
			state_machine.player.velocity.x = current_speed
			if state_machine.player.is_on_floor():
				state_machine.change_state_to("MoveState")
			
	
	if Input.is_action_just_pressed("jump"):
		if state_machine.current_state.is_v_movement_allowed:
			state_machine.change_state_to("JumpState")
		if jump_ray_cast.is_colliding() and not state_machine.player.is_on_floor():
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
	
	if Input.is_action_just_pressed("block") and can_use_block:
		if state_machine.current_state.is_block_allowed:
			if not state_machine.current_state_is("BlockState"):
				state_machine.change_state_to("BlockState")
	if Input.is_action_just_released("block") and can_use_block:
		if state_machine.current_state.is_block_allowed:
			state_machine.change_state_to("IdleState")
		
	handle_wall_slide()
	
	if get_input_direction() == 0 and state_machine.current_state_is("MoveState"):
		current_speed = 0
		state_machine.change_state_to("RunStopState")
	
	

func get_input_direction():
	return Input.get_action_strength("left") * -1 + Input.get_action_strength("right")

func handle_wall_slide():
	if wall_slide_ray_cast.is_colliding() and not state_machine.player.is_on_floor():
		var direction = wall_slide_ray_cast.get_collision_normal().x
		if not state_machine.current_state_is("WallSlide") and get_input_direction() == -direction:
			state_machine.change_state_to("WallSlide")

func await_block_awailable(time: float):
	var timer = get_tree().create_timer(time)
	can_use_block = false
	await timer.timeout
	can_use_block = true

func is_able_to_jump() -> bool:
	return true

