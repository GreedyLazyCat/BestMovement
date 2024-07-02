class_name AnotherTestLevel
extends Level

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_player():
	return player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
