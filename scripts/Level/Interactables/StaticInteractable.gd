class_name StaticInteractable
extends Node

@export var interaction_area: Area2D

var player_is_in_area: bool = false

var player: Player

signal interacted

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(interaction_area, "Interaction area is not connected")
	interaction_area.body_entered.connect(self.on_body_entered)
	interaction_area.body_exited.connect(self.on_body_exited)

func on_body_exited(body):
	if body is Player:
		player_is_in_area = false

func on_body_entered(body):
	if body is Player:
		player_is_in_area = true
		player = body

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and player_is_in_area:
		interacted.emit()
