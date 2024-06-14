class_name Hound
extends CharacterBody2D

@onready var state_machine = $HoundStateMachine
@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $HurtBox
@onready var attack_ray_cast = $AttackRayCast
@onready var jump_ray_cast = $JumpRayCast
@onready var hitbox = $HitBox
@onready var health_handler = $HealthHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.entity = self
	hurtbox.hurted.connect(self.on_hit)
	health_handler.dead.connect(self.on_death)

func on_death():
	queue_free()

	
func on_hit(hitbox: HitBox):
	health_handler.deal_damage(hitbox.damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = state_machine.get_direction(self)
	if direction > 0:
		sprite.flip_h = false
		
	else:
		sprite.flip_h = true
	
	attack_ray_cast.scale.x = direction
	jump_ray_cast.scale.x = direction
	hitbox.scale.x = direction
	
	if attack_ray_cast.is_colliding() and not state_machine.current_state_is("AttackState"):
		state_machine.change_state_to("AttackState")
	if jump_ray_cast.is_colliding() and not state_machine.current_state_is("FallState"):
		state_machine.change_state_to("JumpState")

func _physics_process(delta):
	move_and_slide()
