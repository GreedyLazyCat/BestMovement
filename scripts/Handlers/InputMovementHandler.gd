class_name InputMovementHandler
extends Node

@export var state_machine: StateMachine
@export var jump_ray_cast: RayCast2D
@export var wall_slide_ray_cast: RayCast2D
@export var dash_bar_handler: DashBarHandler
@export var await_block_time: float
@export_group("Block")
@export var attack_after_block_time: float
@export var attack_after_block_decrease_amount: float
@export_group("Permissions")
@export var moving_allowed: bool = true
@export var jumping_allowed: bool = true
@export var dashing_allowed: bool = true
@export var attacking_allowed: bool = true
@export var blocking_allowed: bool = true



var block_time: float
var need_to_handle_block: bool


var current_speed: float

var jump_buffered: bool = false
var can_use_block: bool = true

func _physics_process(delta):
	if jump_buffered and state_machine.player.is_on_floor():
		jump_buffered = false
		state_machine.change_state_to("JumpState")
	
	var action_strength = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if action_strength != 0 and moving_allowed:
		if state_machine.current_state.is_h_movement_allowed:
			current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
			state_machine.player.velocity.x = action_strength * current_speed
			
			if state_machine.player.is_on_floor():
				state_machine.change_state_to("MoveState")
	#print(current_speed)
	
	#if Input.is_action_pressed("right"):
		#if state_machine.current_state.is_h_movement_allowed:
			#current_speed = lerp(current_speed, state_machine.speed, state_machine.acceleration)
			#state_machine.player.velocity.x = current_speed
			#if state_machine.player.is_on_floor():
				#state_machine.change_state_to("MoveState")
			
	
	if Input.is_action_just_pressed("jump") and jumping_allowed:
		if state_machine.current_state.is_v_movement_allowed:
			state_machine.change_state_to("JumpState")
		if jump_ray_cast.is_colliding() and not state_machine.player.is_on_floor():
				jump_buffered = true
	
	if Input.is_action_just_pressed("dash") and dashing_allowed:
		if state_machine.current_state.is_dash_allowed and dash_bar_handler.dash_avaliable():
			if not state_machine.player.is_on_floor():
				if not state_machine.did_air_dash:
					state_machine.change_state_to("GroundDashState")
			else:
				state_machine.change_state_to("GroundDashState")
		
	if Input.is_action_just_pressed("attack") and attacking_allowed:
		if state_machine.current_state.is_attack_allowed:
			state_machine.change_state_to("AttackState")
			if state_machine.prev_state_is("BlockState"):
					start_block_await()
	
	if Input.is_action_just_pressed("block") and can_use_block and blocking_allowed:
		if state_machine.current_state.is_block_allowed:
			if not state_machine.current_state_is("BlockState"):
				state_machine.change_state_to("BlockState")
				if state_machine.prev_state_is("AttackState"):
					start_block_await()
	
	if Input.is_action_just_released("block"):
		if state_machine.current_state_is("BlockState"):
			state_machine.change_state_to("IdleState")
			
	handle_wall_slide()
	
	await_block_awailable(delta)
	
	if action_strength == 0:
		current_speed = 0
		if state_machine.current_state_is("MoveState"):
			state_machine.change_state_to("RunStopState")
	
	

func get_input_direction():
	return sign(Input.get_action_strength("left") * -1 + Input.get_action_strength("right"))

func start_block_await():
	need_to_handle_block = true
	block_time = attack_after_block_time

func handle_wall_slide():
	if wall_slide_ray_cast.is_colliding() and not state_machine.player.is_on_floor() \
	and state_machine.current_state.is_wall_slide_allowed:
		var direction = wall_slide_ray_cast.get_collision_normal().x
		if not state_machine.current_state_is("WallSlide") and get_input_direction() == -direction:
			state_machine.change_state_to("WallSlide")

func await_block_awailable(delta):
	if need_to_handle_block:
		can_use_block = false
		block_time = max(block_time - attack_after_block_decrease_amount * delta, 0)
		if block_time == 0:
			need_to_handle_block = false
			can_use_block = true

func is_able_to_jump() -> bool:
	return true
