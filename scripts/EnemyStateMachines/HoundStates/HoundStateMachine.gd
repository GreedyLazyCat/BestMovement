class_name HoundStateMachine
extends EntityStateMachine

@export var detection_area: Area2D

@export_group("Gravity Values")
@export var acceleration: float




var entity: Hound

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
		is_chasing = true
		is_player_in_detection_area = true

func on_player_leaved(body):
	if body is Player:
		is_player_in_detection_area = false

func _physics_process(delta):
	get_direction(entity)
	super(delta)
	if disable_ai:
		entity.velocity.x = 0.0
		change_state_to("IdleState")

func change_state_to(state_name: String):
	if current_state.name == "StunState":
		return
	super(state_name)

func change_state(from: State, to: String):
	if is_chasing and (to == "IdleState" or to == "WanderState"):
		super(from, "ChaseState")
		return
	super(from, to)
