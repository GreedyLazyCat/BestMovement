class_name SwordsMan
extends CharacterBody2D

@onready var state_machine = $SwordsManStateMachine
@onready var edge_check_raycast = $EdgeCheck
@onready var sprite = $AnimatedSprite2D
@onready var health_handler = $HealthHandler
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var attack_ray_cast = $AttackRayCast

@export var path_finder: Pathfinder

var edge_check_position

func _ready():
	edge_check_position = edge_check_raycast.position.x
	health_handler.dead.connect(self.on_dead)
	hurtbox.hurted.connect(self.on_hit)
	
	state_machine.entity = self
	
func on_hit(hitbox: HitBox):
	health_handler.deal_damage(hitbox.damage)
	
func on_dead():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = state_machine.get_direction(self)
	if direction > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	#attack_ray_cast.scale.x = direction
	attack_ray_cast.scale.x = direction
	hitbox.scale.x = direction
	#hitbox.scale.x = direction
	edge_check_raycast.position.x = -edge_check_position * direction
	
	if attack_ray_cast.is_colliding() and not state_machine.current_state_is("AttackState"):
		state_machine.change_state_to("AttackState")
	
func _physics_process(delta):
	move_and_slide()
