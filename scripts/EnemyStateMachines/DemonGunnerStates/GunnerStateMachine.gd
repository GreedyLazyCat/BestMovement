class_name GunnerStateMachine
extends Node

var states: Dictionary


var prev_state: GunnerState
var entity: GunnerDemon

var player: Player

@export var current_state: GunnerState
@export var detection_area: Area2D
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

var restricted_transitions: Dictionary

var wander_direction: int

var is_chasing: bool = false

var is_player_in_detection_area: bool = false

func _ready():
	for child in get_children():
		if child is State:
			child.transitioned.connect(self.change_state)
			child.state_machine = self
	current_state.enter()
	detection_area.body_entered.connect(self.on_player_detected)

func on_player_detected(body):
	if body is Player:
		change_state_to("GunnerChaseState")
		player = body
		is_chasing = true
		is_player_in_detection_area = true

func on_player_leaved(body):
	if body is Player:
		is_player_in_detection_area = false

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.update_physics(delta)

func change_state_to(to: String):
	var to_state = get_node(to)
	if to_state != current_state:
		current_state.exit()
		to_state.enter()
		prev_state = current_state
		current_state = to_state
	

func current_state_is(state_name: String) -> bool:
	return current_state.name == state_name

func change_to_prev_state():
	current_state.exit()
	prev_state.enter()
	current_state = prev_state

func change_state(from: State, to: State):
	if is_chasing and (to.name == "GunnerIdleState" or to.name == "GunnerWanderState"):
		change_state_to("GunnerChaseState")
		return
	from.exit()
	to.enter()
	prev_state = current_state
	current_state = to
	
