class_name EntityChaseState
extends EntityState

@export var stop_chase_margin: int = 10
@export var runaway_distance: int = 20

var runaway_mode: bool = false
var path_finder: Pathfinder
var path: Array = []
var current_path_point

func enter():
	path_finder = state_machine.entity.path_finder as Pathfinder
	if path_finder and state_machine.player:
		calc_path()
	state_machine.sprite.play("Run")

func calc_path():
	var closest_id = path_finder.graph.get_closest_point(state_machine.entity.global_position)
	var closest_player_id = path_finder.graph.get_closest_point(state_machine.player.global_position)
	path = path_finder.graph.get_point_path(closest_id, closest_player_id)
	if len(path) != 0:
		path.append(state_machine.player.global_position)
	#print(path)
	#path_finder.draw_path(path)
	current_path_point = 0

func print_id_path(path):
	var res = "["
	for i in path:
		res += str(path_finder.get_point_id(i)) + ", "
	res += "]"
	print(res)

func update_physics(delta):
	var path_len = len(path)
	if path_len == 0:
		state_machine.is_chasing = false
		transitioned.emit(self, "IdleState")
	if state_machine.player and path_len != 0:
		var path_point = path[current_path_point]
		var direction = state_machine.entity.global_position.direction_to(path_point)
		var distance = abs(path_point.x - state_machine.entity.global_position.x)
		var distance_to_player = state_machine.entity.global_position.distance_to(state_machine.player.global_position)
		var direction_to_player = state_machine.entity.global_position.direction_to(path_point)
		if distance > 16:
			state_machine.entity.velocity.x = state_machine.speed * sign(direction.x)
		else:
			var next_path_point = current_path_point + 1
			if next_path_point < path_len:
				var from_id = path_finder.get_point_id(path[current_path_point])
				var to_id = path_finder.get_point_id(path[next_path_point])
				var edge = Vector2i(from_id, to_id)
				if edge in path_finder.jump_edges:
					var jump_distance = abs(path[next_path_point].x - state_machine.entity.global_position.x)
					state_machine.speed = jump_distance / (state_machine.jump_time_to_peak + state_machine.jump_time_to_descent)
					state_machine.entity.velocity.x = 1 * sign(direction.x)
					transitioned.emit(self, "JumpState")
				current_path_point = next_path_point
			else:
				calc_path()
		if distance_to_player < distance:
			#state_machine.entity.velocity.x = state_machine.speed * sign(direction.x)
			current_path_point = len(path) - 1
				#state_machine.is_chasing = false
				#transitioned.emit(self, "IdleState")
			
		
		#var direction = state_machine.entity.global_position.direction_to(state_machine.player.global_position)
		#var distance = abs(state_machine.player.global_position.x - state_machine.entity.global_position.x)
		#if not runaway_mode:
			#if distance > runaway_distance:
				#state_machine.entity.velocity.x = state_machine.speed * sign(direction.x)
			#else:
				#runaway_mode = true
		#else:
			#if distance < runaway_distance + stop_chase_margin:
				#state_machine.entity.velocity.x = state_machine.speed * sign(direction.x) * -1
			#else:
				#runaway_mode = false
	if not state_machine.entity.is_on_floor():
		transitioned.emit(self, "FallState")
	
