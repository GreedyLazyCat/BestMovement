class_name SwordsMan
extends CharacterBody2D

@onready var state_machine = $SwordsManStateMachine
@onready var edge_check_raycast = $EdgeCheck
@onready var sprite = $AnimatedSprite2D
@onready var health_handler = $HealthHandler
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var attack_ray_cast = $AttackRayCast
@onready var color_hit_timer = $ColotHitTimer
@onready var parts = preload("res://scenes/Entities/SwordsMan/SwordsManParts.tscn")

@export var path_finder: Pathfinder

var edge_check_position

func _ready():
	edge_check_position = edge_check_raycast.position.x
	health_handler.dead.connect(self.on_dead)
	hurtbox.hurted.connect(self.on_hit)
	hitbox.hitted.connect(self.on_hurt)
	hurtbox.set_collision_mask_value(32, true)
	state_machine.entity = self

func on_hurt(blocked: bool):
	if blocked and hitbox.is_blockable():
		if state_machine.current_state.has_method("next_attack_phase"):
			state_machine.current_state.next_attack_phase()
		state_machine.change_state_to("StunState")
		state_machine.entity.velocity.x = state_machine.speed * -state_machine.get_direction(state_machine.entity)
	
func on_hit(hitbox: HitBox):
	health_handler.deal_damage(hitbox.damage)
	color_hit_timer.color_hit(Vector4(255.0,255.0,255.0,255.0), 1)
	
func on_dead():
	var new_parts = parts.instantiate() as EntityParts
	
	get_tree().root.call_deferred("add_child", new_parts)
	new_parts.set_deferred("global_position", global_position) 
	new_parts.call_deferred("apply_impulses", state_machine.player.get_direction())
	new_parts.call_deferred("start_deletion_timer")
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
