class_name HurtBox
extends Area2D

signal hurted(hitbox: HitBox)
@export var collision_shape: CollisionShape2D

func _ready():
	assert(collision_shape, "Collision shape not referenced")
	area_entered.connect(self._on_area_enter)
# Called when the node enters the scene tree for the first time.

func _on_area_enter(hitbox: HitBox):
	if not collision_shape.disabled:
		emit_signal("hurted", hitbox)
		hitbox.hitted.emit()

