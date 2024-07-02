class_name LevelConditionChecker
extends Node

signal all_conditions_done

var conditions: Array[BaseLevelCondition]

var checking = true

func _ready():
	for node in get_children():
		if node is BaseLevelCondition:
			conditions.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if checking:
		var all_done = true
		for condition in conditions:
			if not condition.is_done():
				all_done = false
				break
		if all_done:
			all_conditions_done.emit()
			checking = false
		
