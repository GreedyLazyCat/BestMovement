class_name PathNode
extends Node2D

@onready var label = $Label
var text = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
