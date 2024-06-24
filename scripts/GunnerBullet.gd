class_name GunnerBullet
extends Node2D

var direction: int
@export var speed: int
@onready var hitbox = $HitBox
@onready var sprite = $AnimatedSprite2D
#@onready var world_collision_area = $Area2D
var player: Player

func _ready():
	hitbox.hitted.connect(self.on_hurt)
	sprite.animation_finished.connect(self.on_anim_finished)
	hitbox.direction = direction

func get_dir_from_bool(from: bool):
	return -1 if from else 1

func on_hurt(is_blocking: bool):
	
	if is_blocking and get_dir_from_bool(player.sprite.flip_h) != direction:
		direction *= -1
		hitbox.set_collision_layer_value(32, true)
		
	else:
		sprite.play("Explosion")
	
func on_anim_finished():
	if sprite.animation == "Explosion":
		queue_free()

func _process(delta):
	if direction > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	if sprite.animation != "Explosion":
		global_position.x += speed * delta * direction
