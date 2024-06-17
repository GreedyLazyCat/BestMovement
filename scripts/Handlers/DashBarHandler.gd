class_name DashBarHandler
extends Node


@export var dash_max_value: float = 90
@export var dash_cost: float = 30
@export var dash_refill_speed: float = 10
@export var timer: Timer

var dash_value: float

var can_refill = false

signal value_changed


func _ready():
	timer.timeout.connect(self.on_timeout)
	dash_value = dash_max_value

func on_timeout():
	can_refill = true
	
func use_dash():
	can_refill = false
	dash_value = max(0, dash_value - dash_cost)
	timer.stop()
	timer.start()
	value_changed

func dash_avaliable() -> bool:
	return dash_value >= 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_refill:
		dash_value = min(dash_value + dash_refill_speed * delta, dash_max_value)
