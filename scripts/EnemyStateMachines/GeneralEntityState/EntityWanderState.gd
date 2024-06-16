class_name EntityWanderState
extends EntityState

@export_group("Wander range")
@export var wander_time_bottom: float
@export var wander_time_top: float
@export var edge_check: RayCast2D
@export_group("Sprite Settings")
@export var animation_name: String


var wander_direction: int = 1

func _ready():
	assert(edge_check, "Edge check ray cast isnt connected")

func enter():
	state_machine.sprite.play(animation_name)
	var time = randf_range(wander_time_bottom, wander_time_top)
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(self.on_stop_timer)

func on_stop_timer():
	if state_machine.current_state_is(self.name):
		wander_direction *= -1
		transitioned.emit(self, "IdleState")

func update_physics(delta):
	if not edge_check.is_colliding():
		wander_direction *= -1
		transitioned.emit(self, "IdleState")
	if not state_machine.entity.is_on_floor():
		transitioned.emit(self, "FallState")
	state_machine.entity.velocity.x = state_machine.speed * wander_direction
