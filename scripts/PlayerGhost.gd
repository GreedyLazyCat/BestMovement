extends Node2D

@onready var sprite = $Sprite2D
@export var fade_time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	await_destroy()

func await_destroy():
	var timer = get_tree().create_timer(fade_time)
	await timer.timeout
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
