class_name GunnerDemon
extends CharacterBody2D

@onready var hurtbox = $HurtBox
@onready var health_handler = $HealthHandler
@onready var parts = preload("res://scenes/Entities/GunnerDemon/DemonGunnerParts.tscn")
@onready var state_machine = $GunnerStateMachine
@onready var sprite = $AnimatedSprite2D
@onready var jump_ray_cast = $RayCast2D
@onready var shoot_ray_cast = $ShootRayCast

var direction: int = 1
var prev_direction: int = 1

var damage_direction: int

# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox.hurted.connect(self.on_hit)
	health_handler.dead.connect(self.on_death)
	state_machine.entity = self
	
	


func on_hit(hitbox: HitBox):
	damage_direction = hitbox.direction
	health_handler.deal_damage(hitbox.damage)
	state_machine.change_state_to("StunState")
	color_hit(Vector4(255.0,255.0,255.0,255.0), 1, 0.1)

func on_death():
	var new_parts = parts.instantiate() as DemonGunnerParts
	new_parts.set_deferred("global_position", global_position)
	get_tree().root.call_deferred("add_child", new_parts)
	new_parts.call_deferred("apply_impulses", damage_direction)
	new_parts.call_deferred("start_deletion_timer")
	queue_free()

func _process(delta):
	if get_direction() > 0:
		sprite.flip_h = false
		jump_ray_cast.position.x = 6
		#shoot_ray_cast.position.x = 6
	else:
		jump_ray_cast.position.x = -4
		#shoot_ray_cast.position.x = -4
		sprite.flip_h = true
	shoot_ray_cast.scale.x = get_direction()
	jump_ray_cast.scale.x = get_direction()
	
	if jump_ray_cast.is_colliding() and not state_machine.current_state_is("JumpState"):
		state_machine.change_state_to("JumpState")
	
	if shoot_ray_cast.is_colliding() \
	and not state_machine.current_state_is("ShootState")\
	and not state_machine.current_state_is("StunState") \
	and is_on_floor():
		state_machine.change_state_to("ShootState")
	
func _physics_process(delta):
	move_and_slide()

func color_hit(color:Vector4, alpha:float, duration):
	sprite.material.set_shader_parameter('Amount', alpha)
	sprite.material.set_shader_parameter('FillColor', color)
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	sprite.material.set_shader_parameter('Amount', 0.0)

func get_direction() -> int:
	direction = sign(velocity.x)
	if direction == 0:
		return prev_direction
	prev_direction = direction
	return direction
