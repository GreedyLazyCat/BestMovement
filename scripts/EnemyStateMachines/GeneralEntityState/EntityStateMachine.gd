class_name EntityStateMachine
extends Node

var states: Dictionary


var prev_state: State

var player: Player
@export_group("States")
@export var current_state: State
@export var state_prefix: String
@export_group("Gravity Values")
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float
@export var jump_distance: float
@export_group("Nodes")
@export var sprite: AnimatedSprite2D
@export var walk_particles: GPUParticles2D
@export_group("Debug")
@export var print_current_state: bool = false

@onready var jump_gravity = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity =  (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
@onready var jump_velocity = (-2.0 * jump_height) / jump_time_to_peak
@onready var speed = jump_distance / (jump_time_to_peak + jump_time_to_descent)

var direction: int = 1
var prev_direction: int = 1


func _ready():
	
	for child in get_children():
		if child is State:
			child.transitioned.connect(self.change_state)
			child.state_machine = self
	
	current_state.enter()

func _process(delta):
	if current_state:
		if print_current_state:
			print(current_state.name)
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.update_physics(delta)

func change_state_to(to: String):
	var to_state = get_node(state_prefix + to)
	if to_state != current_state:
		current_state.exit()
		to_state.enter()
		prev_state = current_state
		current_state = to_state
	

func current_state_is(state_name: String) -> bool:
	if not state_prefix in state_name:
		return current_state.name == state_prefix + state_name
	else:
		return current_state.name == state_name

func change_to_prev_state():
	current_state.exit()
	prev_state.enter()
	current_state = prev_state

func change_state(from: State, to: String):
	var to_state = get_node(state_prefix + to)
	if to_state:
		from.exit()
		to_state.enter()
		prev_state = current_state
		current_state = to_state
	
func get_direction(entity: CharacterBody2D) -> int:
	direction = sign(entity.velocity.x)
	if direction == 0:
		return prev_direction
	prev_direction = direction
	return direction
	
