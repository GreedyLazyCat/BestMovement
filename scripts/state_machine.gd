class_name StateMachine
extends Node

var states: Dictionary

@export var current_state: PlayerState
var prev_state: State
var player: Player
@export_group("Nodes")
@export var sprite: AnimatedSprite2D
@export var walk_particles: GPUParticles2D

@export_group("Gravity Values")
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float
@export var jump_distance: float

@export var acceleration: float
@export var dash_force: int

#@export var speed: int

@onready var jump_gravity = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity =  (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
@onready var jump_velocity = (-2.0 * jump_height) / jump_time_to_peak
@onready var speed = jump_distance / (jump_time_to_peak + jump_time_to_descent)

@onready var player_ghost = preload("res://scenes/PlayerGhost.tscn")

var restricted_transitions: Dictionary

var did_air_dash = false

func _ready():
	restricted_transitions = {"AirDashState": ["MoveState"], "GroundDashState": ["MoveState"]}
	for child in get_children():
		if child is State:
			if not current_state:
				current_state = child
			child.transitioned.connect(self.change_state)
			child.state_machine = self
	current_state.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.update_physics(delta)

func change_state_to(to: String):
	if restricted_transitions.keys().has(current_state.name):
		if to in restricted_transitions[current_state.name]:
			return
	var to_state = get_node(to)
	if to_state != current_state:
		current_state.exit()
		to_state.enter()
		prev_state = current_state
		current_state = to_state
	#print(current_state.name)d
	

func current_state_is(state_name: String) -> bool:
	return current_state.name == state_name

func is_dashing() -> bool:
	return current_state.name == "GroundDashState" or current_state.name == "AirDashState"

func change_to_prev_state():
	current_state.exit()
	prev_state.enter()
	current_state = prev_state
	

func change_state(from: State, to: State):
	from.exit()
	to.enter()
	prev_state = current_state
	current_state = to
	#print(current_state.name)
	
