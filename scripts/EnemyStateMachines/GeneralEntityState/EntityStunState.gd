class_name EntityStunState
extends EntityState

@export var animation_name: String
@export var state_after_stun: String
@export var stun_time_sec: float
@export var alpha_flash_count: int = 2

var tween: Tween

func enter():
	state_machine.entity.velocity.y = 0 
	state_machine.sprite.play(animation_name)
	animate_opacity(alpha_flash_count)
	get_tree().create_timer(stun_time_sec).timeout.connect(self.on_timeout)
	
func on_timeout():
	state_machine.entity.velocity.x = 1 * -state_machine.get_direction(state_machine.entity)
	transitioned.emit(self, state_after_stun)

func animate_opacity(flash_count: int):
	if tween:
		tween.kill()
	tween = get_tree().create_tween() 
	var interval_count = flash_count * 2
	var interval_time = stun_time_sec / float(interval_count)
	var color_a_zero = Color(state_machine.sprite.modulate)
	color_a_zero.a = 0.0
	var color_a_one = Color(state_machine.sprite.modulate)
	color_a_one.a = 1.0
	for i in range(interval_count):
		if i % 2 == 0:
			tween.tween_property(state_machine.sprite, "modulate", color_a_zero, interval_time).from_current()
		else:
			tween.tween_property(state_machine.sprite, "modulate", color_a_one, interval_time).from_current()

func update_physics(delta):
	state_machine.entity.velocity.x = lerp(state_machine.entity.velocity.x, 0.0, 0.2)

func exit():
	state_machine.sprite.set_deferred("modulate.a", 1.0)
