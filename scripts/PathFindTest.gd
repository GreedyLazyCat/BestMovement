extends Node2D

@onready var tiles = $TileMap
@onready var path_finder = $Pathfinder

var test = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#path_finder.tile_map = tiles
	#path_finder.place_nodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if test:
		#path_finder.place_nodes()
		#test = false
