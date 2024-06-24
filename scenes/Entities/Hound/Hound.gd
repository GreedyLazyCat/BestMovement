class_name Hound
extends CharacterBody2D

@onready var state_machine = $HoundStateMachine
@onready var sprite = $AnimatedSprite2D
@onready var hurtbox = $HurtBox
@onready var attack_ray_cast = $AttackRayCast
@onready var jump_ray_cast = $JumpRayCast
@onready var hitbox = $HitBox
@onready var health_handler = $HealthHandler
@onready var edge_check_raycast = $EdgeCheckRight
@onready var color_hit_timer = $ColotHitTimer
@onready var parts = preload("res://scenes/Entities/Hound/HoudParts.tscn")
@export var path_finder: Pathfinder

var edge_check_position

# Called when the node enters the scene tree for the first time.
func _ready():
	edge_check_position = edge_check_raycast.position.x
	state_machine.entity = self
	hurtbox.hurted.connect(self.on_hit)
	hitbox.hitted.connect(self.on_hurt)
	hurtbox.set_collision_mask_value(32, true)
	health_handler.dead.connect(self.on_death)

func on_death():
	var new_parts = parts.instantiate() as EntityParts
	
	get_tree().root.call_deferred("add_child", new_parts)
	new_parts.set_deferred("global_position", global_position) 
	new_parts.call_deferred("apply_impulses", state_machine.player.get_direction())
	new_parts.call_deferred("start_deletion_timer")
	queue_free()

func on_hurt(is_blocking: bool):
	if is_blocking:
		state_machine.change_state_to("StunState")
		state_machine.entity.velocity.x = state_machine.speed * -state_machine.get_direction(state_machine.entity)

func on_hit(hitbox: HitBox):
	health_handler.deal_damage(hitbox.damage)
	color_hit_timer.color_hit(Vector4(255.0,255.0,255.0,255.0), 1)

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
	edge_check_raycast.position.x = -edge_check_position * direction
	
	if attack_ray_cast.is_colliding() and not state_machine.current_state_is("AttackState"):
		state_machine.change_state_to("AttackState")
	#if jump_ray_cast.is_colliding() and not state_machine.current_state_is("FallState"):
		#state_machine.change_state_to("JumpState")

func _physics_process(delta):
	move_and_slide()
