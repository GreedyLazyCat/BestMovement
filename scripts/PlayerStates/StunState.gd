class_name StunState
extends PlayerState


@export var stun_time_sec: float = 0.1
@export var hurtbox: HurtBox
@export var timer: Timer
@export var alpha_flash_count: int

var tween: Tween

func enter():
	state_machine.sprite.play("Knockback")
	is_attack_allowed = false
	is_block_allowed = false
	is_dash_allowed = false
	is_h_movement_allowed = false
	is_v_movement_allowed = false
	if state_machine.prev_state_is("BlockState"):
		hurtbox.set_deferred("is_blocking", true)
	state_machine.sprite.set_deferred("modulate.a", 1.0)
	animate_opacity(alpha_flash_count)
	get_tree().create_timer(stun_time_sec).timeout.connect(self.on_timeout)
	
	

	

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
	
	

func on_timeout():
	state_machine.player.velocity.x = 1 * -state_machine.player.get_direction()
	state_machine.player.sprite.modulate.a = 1.0
	
	transitioned.emit(self, "IdleState")

func update_physics(delta):
	state_machine.player.velocity.x = lerp(state_machine.player.velocity.x , 0.0, 0.35)



func exit():
	state_machine.sprite.set_deferred("modulate.a", 1.0)
	hurtbox.set_deferred("is_blocking", false)
