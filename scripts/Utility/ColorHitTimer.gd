class_name ColotHitTimer
extends Timer

@export var sprite: AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(sprite, "Sprite is not connected")
	timeout.connect(self.disable_color)


func disable_color():
	sprite.material.set_shader_parameter('Amount', 0.0)
	

func color_hit(color:Vector4, alpha:float):
	sprite.material.set_shader_parameter('Amount', alpha)
	sprite.material.set_shader_parameter('FillColor', color)
	stop()
	start()
