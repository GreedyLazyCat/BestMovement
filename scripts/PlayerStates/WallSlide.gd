class_name WallSlide
extends PlayerState

@export var ray_cast: RayCast2D
@export var slow_amout: float


func _ready():
	assert(ray_cast, "RayCast isnt connected")
	
func enter():
	state_machine.walk_particles.emitting = false
	is_h_movement_allowed = false
	state_machine.sprite.play("WallSlide")
	state_machine.player.velocity.x = 0
	state_machine.player.velocity.y = 0
	

func update_physics(delta):
	if not ray_cast.is_colliding():
		transitioned.emit(self, "FallState")
	if state_machine.player.is_on_floor():
		transitioned.emit(self, "IdleState")
	
	var collision_direction = ray_cast.get_collision_normal().x
	
	if Input.is_action_just_pressed("jump"):
		state_machine.player.velocity.x = -state_machine.speed * get_input_direction()
		transitioned.emit(self, "JumpState")
	elif collision_direction == get_input_direction():
		transitioned.emit(self, "FallState")
	
	
	state_machine.player.velocity.y += state_machine.fall_gravity * delta * slow_amout

func get_input_direction():
	return Input.get_action_strength("left") * -1 + Input.get_action_strength("right")

func any_movement_pressed() -> bool:
	return (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and not Input.is_action_pressed("jump") 
	
