class_name DeathState
extends PlayerState


func enter():
	state_machine.sprite.play("Death")
	is_attack_allowed = false
	is_h_movement_allowed = false
	is_v_movement_allowed = false
	is_dash_allowed = false
	is_block_allowed = false
	state_machine.player.velocity = Vector2(0, 0)
