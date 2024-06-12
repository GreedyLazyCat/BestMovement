class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var hurtbox = $HurtBox

var prev_direction: int
var direction: int

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = 1
	prev_direction = 1
	state_machine.player = self
	hurtbox.hurted.connect(self.on_hit)

func on_hit(hurting_hitbox: HitBox):
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_direction() > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	

func _physics_process(delta):
	move_and_slide()
	
func get_direction() -> int:
	direction = sign(velocity.x)
	if direction == 0:
		return prev_direction
	prev_direction = direction
	return direction
