class_name InCodeTimer
extends Node

var max_time: float
var time: float
var timer_step: float

var started: bool = false

signal timeout

func start():
	started = true
	time = max_time

func stop():
	started = false

func process_timer(delta):
	if started:
		time = max(time - timer_step * delta, 0)
		if time == 0:
			started = false
			timeout.emit()
			
func _process_physics(delta):
	process_timer(delta)
