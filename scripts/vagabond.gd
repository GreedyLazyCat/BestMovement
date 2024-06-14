class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var hit_particles = $HurtParticles
@onready var health_handler = $HealthHandler
@export var invinsible_dash: bool = false
@export var label: Label
@export_group("Camera")
@export var camera: Camera2D
@export var shake_offset: float

var camera_offset: float = 0

var prev_direction: int
var direction: int

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = 1
	prev_direction = 1
	state_machine.player = self
	hurtbox.hurted.connect(self.on_hit)
	hitbox.hitted.connect(self.on_hurt)
	health_handler.dead.connect(self.on_death)

func death_stagger(time:float):
	var prev = Engine.time_scale
	var timer = get_tree().create_timer(time * 0.01)
	Engine.time_scale = 0.01
	await timer.timeout
	Engine.time_scale = prev

func on_hurt():
	camera_offset = shake_offset

func random_offset() -> Vector2:
	return Vector2(randf_range(-camera_offset, camera_offset), randf_range(-camera_offset, camera_offset))
	
func on_hit(hurting_hitbox: HitBox):
	camera_offset = shake_offset
	color_hit(Vector4(255.0,255.0,255.0,255.0), 1, 0.1)
	health_handler.deal_damage(hurting_hitbox.damage)

func on_death():
	state_machine.change_state_to("DeathState")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if label:
		label.text = "HP: " + str(health_handler.health)
	if get_direction() > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	if camera:
		camera.offset = random_offset()
		camera_offset = lerp(camera_offset, 0.0, 0.3)
	

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
