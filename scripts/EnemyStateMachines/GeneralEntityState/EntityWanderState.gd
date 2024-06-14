class_name EntityWanderState
extends EntityState

@export_group("Wander range")
@export var wander_time_bottom: float
@export var wander_time_top: float
@export_group("Sprite Settings")
@export var animation_name: String


var wander_direction: int = 1

func enter():
	state_machine.sprite.play(animation_name)
	var time = randf_range(wander_time_bottom, wander_time_top)
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(self.on_stop_timer)

func on_stop_timer():
	wander_direction *= -1
	if state_machine.current_state_is(self.name):
		transitioned.emit(self, "IdleState")

func update_physics(delta):
	if not state_machine.entity.is_on_floor():
		transitioned.emit(self, "FallState")
	state_machine.entity.velocity.x = state_machine.speed * wander_direction
