class_name GunnerStunState
extends EntityState

@export var stun_time: float

func enter():
	state_machine.sprite.play("Idle")
	state_machine.entity.velocity.x = 0 
	await_stun()

func await_stun():
	var timer = get_tree().create_timer(stun_time)
	await timer.timeout
	transitioned.emit(self, "IdleState")
