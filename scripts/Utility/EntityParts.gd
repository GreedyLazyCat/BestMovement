class_name EntityParts
extends Node2D

@export var parts: Array[RigidBody2D]

func apply_impulses(direction):
	var impulse = Vector2(150 * direction, -180)
	for part in parts:
		part.apply_impulse(impulse, Vector2(100 * direction, 100))
		#print(impulse)
		impulse.y = max(impulse.y + 40, 0.0)
		impulse.x += 20 * direction

func start_deletion_timer():
	var timer = get_tree().create_timer(5)
	await timer.timeout
	for part in parts:
		part.queue_free()
	queue_free()
