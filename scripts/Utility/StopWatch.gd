class_name StopWatch
extends Node

@export var stopwatch_enabled: bool = false

var value: float = 0

func reset():
	value = 0

func get_formatted() -> String:
	var mins = int(value) / 60
	var secs = int(value - mins * 60)
	return "%d:%d" % [mins , secs]

func start():
	stopwatch_enabled = true

func stop():
	stopwatch_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stopwatch_enabled:
		value += delta
