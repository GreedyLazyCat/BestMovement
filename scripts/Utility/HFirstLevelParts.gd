class_name HFirstLevelParts
extends EntityParts

@onready var head = $head

func apply_impulses(direction):
	super(direction)
	var impulse = Vector2(100 * direction, -130)
	head.apply_impulse(impulse, Vector2(100 * direction, 100))
	
func start_deletion_timer():
	var timer = get_tree().create_timer(5)
	await timer.timeout
	for part in parts:
		if part == head:
			continue
		part.queue_free()
	var entry_point = get_tree().root.get_node("EntryPoint") as EntryPoint
	
	if is_instance_valid(head):
		head.reparent(entry_point.level)
	queue_free()

