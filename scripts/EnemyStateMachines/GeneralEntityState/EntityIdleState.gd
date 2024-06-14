class_name EntityIdleState
extends EntityState

@export_group("Idle Await Settings")
@export var idle_state_time_bottom: float
@export var idle_state_time_top: float
@export_group("Sprite Settings")
@export var animation_name: String


func enter():
	state_machine.sprite.play(animation_name)
	await_idle_state()

func await_idle_state():
	var idle_state_time = randf_range(idle_state_time_bottom, idle_state_time_top)
	var timer = get_tree().create_timer(idle_state_time)
	await timer.timeout
	if state_machine.current_state_is(self.name):
		transitioned.emit(self, "WanderState")

func update_physics(delta):
	if not state_machine.entity.is_on_floor():
		self.transitioned.emit(self, "FallState")
	state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.35)
