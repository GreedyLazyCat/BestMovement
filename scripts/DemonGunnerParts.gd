class_name DemonGunnerParts
extends Node2D

@onready var head = $head
@onready var body = $body
@onready var weapon = $Weapon
@onready var right_leg = $LegRight

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_impulses(direction):
	var head_x_impulse = randi_range(130, 180)
	var head_y_impulse = -randi_range(130, 180)
	var body_x_impulse = randi_range(130, 180)
	var body_y_impulse = randi_range(-10, 10)
	
	head.apply_impulse(Vector2(head_x_impulse * direction, head_y_impulse), 
	Vector2(100 * direction, 100))
	body.apply_impulse(Vector2(body_x_impulse * direction, body_y_impulse), 
	Vector2(100 * direction, 100))
	weapon.apply_impulse(Vector2(head_x_impulse * direction, head_y_impulse), 
	Vector2(100 * direction, 100))

func start_deletion_timer():
	var timer = get_tree().create_timer(5)
	await timer.timeout
	head.queue_free()
	body.queue_free()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
