class_name Pathfinder
extends Node2D

@export var tile_map: TileMap
@export_group("Debug")
@export var draw_graph: bool = false
@export var test_start: Sprite2D
@export var test_end: Sprite2D


@onready var path_node = preload("res://scenes/Utility/PathNode.tscn")
@onready var line = preload("res://scenes/Utility/Line.tscn")

enum NodeType {Edge, Corner, Regular}

var graph: AStar2D

var setup = true

func _ready():
	graph = AStar2D.new()
	
func _process(delta):
	if setup:
		place_nodes()
		connect_points()
		if draw_graph:
			draw_connecctions()
		draw_path()
		setup = false
func place_nodes():
	var cells = tile_map.get_used_cells(0)
	for cell in cells:
		var cell_type = get_cell_type(cell)
		var parent_id = -1
		if cell_type != NodeType.Regular:
			var above = Vector2i(cell.x, cell.y - 1)
			parent_id = place_one_node(above)
		
		if cell_type == NodeType.Edge:
			var space_state = get_world_2d().direct_space_state
			var left = Vector2i(cell.x - 1, cell.y)
			var right = Vector2i(cell.x + 1, cell.y)
			
			var right_cell_coord = tile_map.to_global(tile_map.map_to_local(right))
			var left_cell_coord = tile_map.to_global(tile_map.map_to_local(left))
			
			if not right in cells:
				place_if_intersects(right, parent_id)
				
			if not left in cells:
				place_if_intersects(left, parent_id)
	for cell in cells:
		var cell_type = get_cell_type(cell)
		if cell_type == NodeType.Corner:
			var left = Vector2i(cell.x - 1, cell.y - 1)
			var right = Vector2i(cell.x + 1, cell.y - 1)
			
			if right in cells:
				connect_corner(cell, right)
			if left in cells:
				connect_corner(cell, left)

func connect_corner(cell: Vector2i, from: Vector2i):
	var cell_coord = tile_map.to_global(tile_map.map_to_local(Vector2i(cell.x, cell.y - 1)))
	
	for i in range(3):
		var up = Vector2i(from.x, from.y - i)
		var up_pos = tile_map.to_global(tile_map.map_to_local(up))
		var point_id = get_point_id(up_pos)
		var parent_point_id = get_point_id(cell_coord)
		if point_id != -1 and parent_point_id != -1:
			graph.connect_points(point_id, parent_point_id)
				

func place_if_intersects(cell: Vector2i, parent_id: int):
	var cell_coord = tile_map.to_global(tile_map.map_to_local(cell))
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(Vector2(cell_coord.x, cell_coord.y), 
	Vector2(cell_coord.x, 1000))
	var result = space_state.intersect_ray(query) as Dictionary
	
	if not result.is_empty():
		var pos = result["position"]
		var tile_pos = tile_map.local_to_map(tile_map.to_local(pos))
		tile_pos.y -= 1
		var id = place_one_node(tile_pos)
		if parent_id != -1:
			graph.connect_points(parent_id, id, false)

func get_point_id(pos: Vector2):
	for id in graph.get_point_ids():
		var graph_pos = graph.get_point_position(id)
		if pos == graph_pos:
			return id
	return -1 

func place_one_node(cell: Vector2i) -> int:
	var global_pos = tile_map.to_global(tile_map.map_to_local(cell))
	var points_count = graph.get_point_count()
	var id = get_point_id(global_pos)
	if id == -1:
		graph.add_point(points_count, global_pos)
		if draw_graph:
			var new_path_node = path_node.instantiate() as PathNode
			new_path_node.global_position = global_pos
			call_deferred("add_child", new_path_node)
			new_path_node.text = str(points_count)
		
		return points_count
	return id

func get_cell_type(cell: Vector2i) -> NodeType:
	var cells = tile_map.get_used_cells(0)
	if cell in cells:
		var above = Vector2i(cell.x, cell.y - 1)
		if not above in cells:
			if (not Vector2i(cell.x + 1, cell.y) in cells and not Vector2i(cell.x + 1, cell.y - 1) in cells) \
			or (not Vector2i(cell.x - 1, cell.y) in cells and not Vector2i(cell.x - 1, cell.y - 1) in cells):
				return NodeType.Edge
			if Vector2i(cell.x + 1, cell.y - 1) in cells or \
			Vector2i(cell.x - 1, cell.y - 1) in cells:
				return NodeType.Corner
	return NodeType.Regular

func connect_points():
	var space = get_world_2d().direct_space_state
	for id in graph.get_point_ids():
		var point_pos = graph.get_point_position(id)
		var closest = -1
		for to_id in graph.get_point_ids():
			var to_point_pos =graph.get_point_position(to_id)
			if point_pos.y == to_point_pos.y and point_pos.x < to_point_pos.x:
				var params = PhysicsRayQueryParameters2D.create(point_pos, to_point_pos)
				var result = space.intersect_ray(params) as Dictionary
				if not result.is_empty():
					continue
				if closest == -1:
					closest = to_id
					continue
				var closest_pos = graph.get_point_position(closest)
				if to_point_pos.x < closest_pos.x:
					closest = to_id
		if closest != -1:
			
			graph.connect_points(id, closest)
				
func draw_path():
	var start_pos = graph.get_closest_point(test_start.global_position)
	var end_pos = graph.get_closest_point(test_end.global_position)
	var path = graph.get_id_path(start_pos, end_pos)
	print(start_pos)
	print(end_pos)
	print(path)
	for i in range(len(path) - 1):
		var from_pos = graph.get_point_position(path[i])
		var to_pos = graph.get_point_position(path[i + 1])
		var new_line = line.instantiate() as Line2D
		new_line.points = [from_pos, to_pos]
		call_deferred("add_child", new_line)

func draw_connecctions():
	for id in graph.get_point_ids():
		var from_pos = graph.get_point_position(id)
		for to_id in graph.get_point_connections(id):
			var to_pos = graph.get_point_position(to_id)
			var new_line = line.instantiate() as Line2D
			new_line.points = [from_pos, to_pos]
			call_deferred("add_child", new_line)
