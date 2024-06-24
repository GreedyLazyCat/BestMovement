class_name Pathfinder
extends Node2D

@export var tile_map: TileMap
@export var jump_tiles_length: int = 3
@export_group("Debug")
@export var draw_graph: bool = false
@export var print_jump_edges: bool = false


@onready var path_node = preload("res://scenes/Utility/PathNode.tscn")
@onready var line = preload("res://scenes/Utility/Line.tscn")

enum NodeType {Edge, Corner, Regular}

var corners: Dictionary
var edges: Dictionary
var jump_edges: Array[Vector2i]


var graph: AStar2D

var setup = true

func _ready():
	graph = AStar2D.new()
	
func _process(delta):
	if setup:
		place_nodes()
		#add_player()
		
		connect_points()
		if draw_graph:
			draw_connecctions()
		#draw_path()
		#print("jump edges")
		if print_jump_edges:
			print(jump_edges)
		#print("edges")
		#for i in edges.keys():
			#print(get_point_id(tile_map.to_global(tile_map.map_to_local(Vector2i(i.x, i.y - 1)))))
		#print("corners")
		#for i in corners.keys():
			#print(get_point_id(tile_map.to_global(tile_map.map_to_local(Vector2i(i.x, i.y - 1)))))
		setup = false
	
	#update_player()

		

#OMG THATS A REAL SPHAGETTI
#Write only shii
func place_nodes():
	var cells = tile_map.get_used_cells(0)
	for cell in cells:
		var cell_type = get_cell_type(cell)
		var parent_id = -1
		if cell_type != NodeType.Regular:
			var above = Vector2i(cell.x, cell.y - 1)
			parent_id = place_one_node(above)
		
		if cell_type == NodeType.Edge:
			edges[cell] = parent_id
		if cell_type == NodeType.Corner:
			corners[cell] = parent_id
	
	for cell in edges.keys():
		var space_state = get_world_2d().direct_space_state
		var left = Vector2i(cell.x - 1, cell.y)
		var right = Vector2i(cell.x + 1, cell.y)
		
		var right_cell_coord = tile_map.to_global(tile_map.map_to_local(right))
		var left_cell_coord = tile_map.to_global(tile_map.map_to_local(left))
		
		if not right in cells:
			place_if_intersects(right, edges[cell])
			
		if not left in cells:
			place_if_intersects(left, edges[cell])
		
		for i in range(1, jump_tiles_length + 1):
			for j in range(0, 4):
				var jump_cell_right = Vector2i(cell.x + i, cell.y + j - 1)
				var jump_cell_left = Vector2i(cell.x - i, cell.y + j - 1)
				#place_one_node(jump_cell_left)
				#place_one_node(jump_cell_right)
				
				
				var right_coord = tile_map.to_global(tile_map.map_to_local(jump_cell_right))
				var left_coord = tile_map.to_global(tile_map.map_to_local(jump_cell_left))
				
				var right_id = get_point_id(right_coord)
				var left_id = get_point_id(left_coord)
				if right_id != -1 and not graph.are_points_connected(edges[cell], right_id)\
				and not Vector2i(cell.x + 1, cell.y) in cells:
					graph.connect_points(edges[cell], right_id, false)
					jump_edges.append(Vector2i(edges[cell], right_id))
				if left_id != -1 and not graph.are_points_connected(edges[cell], left_id)\
				and not Vector2i(cell.x - 1, cell.y) in cells:
					graph.connect_points(edges[cell], left_id, false)
					jump_edges.append(Vector2i(edges[cell], left_id))
					
	
	for cell in corners.keys():
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
			jump_edges.append(Vector2i(parent_point_id, point_id))
			graph.connect_points(point_id, parent_point_id, true)
				

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
				
func draw_path(path):
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
