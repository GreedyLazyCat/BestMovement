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
		if not current_state_is("StunState"):
			change_state_to("ChaseState")
		else:
			print("zalupa")
		player = body
		is_chasing = true
		is_player_in_detection_area = true

func on_player_leaved(body):
	if body is Player:
		is_player_in_detection_area = false

func change_state(from: State, to: String):
	if is_chasing and (to == "IdleState" or to == "WanderState"):
		change_state_to("ChaseState")
		return
	super(from, to)
