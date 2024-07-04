class_name AllEnemiesKilledCondition
extends BaseLevelCondition

@export var enemies_group_name: String

func is_done():
	if not get_tree().get_nodes_in_group(enemies_group_name):
		return true
	return false
