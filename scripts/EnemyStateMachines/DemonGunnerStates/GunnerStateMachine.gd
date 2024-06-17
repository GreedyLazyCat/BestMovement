class_name GunnerStateMachine
extends EntityStateMachine

var entity: GunnerDemon

@export var detection_area: Area2D


@export var acceleration: float
@export var dash_force: int

var restricted_transitions: Dictionary

var wander_direction: int

var is_chasing: bool = false

var is_player_in_detection_area: bool = false

func _ready():
	detection_area.body_entered.connect(self.on_player_detected)
	detection_area.body_exited.connect(self.on_player_leaved)
	super()

func on_player_detected(body):
	if body is Player and not is_chasing:
		player = body
		if not current_state_is("StunState"):
			change_state_to("ChaseState")
		else:
			print("zalupa")
		is_chasing = true
		is_player_in_detection_area = true

func on_player_leaved(body):
	if body is Player:
		is_player_in_detection_area = false

func _physics_process(delta):
	get_direction(entity)
	super(delta)

func change_state(from: State, to: String):
	if is_chasing and (to == "IdleState" or to == "WanderState"):
		change_state_to("ChaseState")
		return
	super(from, to)
	
