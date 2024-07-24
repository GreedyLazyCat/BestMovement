class_name Player
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var hurtbox = $HurtBox
@onready var hitbox = $HitBox
@onready var hit_particles = $HurtParticles
@onready var health_handler = $HealthHandler
@onready var dash_handler = $DashBarHandler
@onready var movement_handler = $InputMovementHandler
@onready var wall_slide_raycast = $WallSlideRayCast
@onready var color_hit_timer = $ColotHitTimer
@onready var inventory_handler = $InventoryHandler


@export var invinsible_dash: bool = false
@export_group("Camera")
@export var camera: Camera2D
@export var shake_offset: float
@export_group("Debug")
@export var print_current_state: bool
@export var print_direction: bool



var camera_offset: float = 0

var prev_direction: int
var direction: int
var camera_shaking: bool = false

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

func on_hurt(is_blocked: bool):
	camera_offset = shake_offset
	camera_shaking = true

func random_offset() -> Vector2:
	return Vector2(randf_range(-camera_offset, camera_offset), randf_range(-camera_offset, camera_offset))
	
func on_hit(hurting_hitbox: HitBox):
	camera_offset = shake_offset
	camera_shaking = true
	#redo this
	if hurting_hitbox.is_blockable() and state_machine.current_state_is("BlockState"):
		if get_direction() != -hurting_hitbox.direction:
			color_hit(Vector4(255.0,255.0,255.0,255.0), 1, 0.1)
			health_handler.deal_damage(hurting_hitbox.damage)
		state_machine.player.velocity.x = state_machine.speed * hurting_hitbox.direction
		state_machine.change_state_to("StunState")
		movement_handler.start_block_await()
		return
	color_hit_timer.color_hit(Vector4(255.0,255.0,255.0,255.0), 1)
	health_handler.deal_damage(hurting_hitbox.damage)

func on_death():
	state_machine.change_state_to("DeathState")
	hurtbox.collision_shape.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_direction() > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	#camera.offset.x = lerp(camera.offset.x, float(10 * get_direction()), 0.1)
	
	wall_slide_raycast.scale.x = get_direction()
	
	if camera and camera_shaking:
		camera.offset = random_offset()
		camera_offset = lerp(camera_offset, 0.0, 0.3)
		if camera_offset == 0.0:
			camera_shaking = false
	
	if print_current_state:
		print(state_machine.current_state.name)
	if print_direction:
		print(get_direction())
	

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
