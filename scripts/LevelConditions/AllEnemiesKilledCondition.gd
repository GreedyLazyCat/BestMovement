class_name AllEnemiesKilledCondition
extends BaseLevelCondition


func is_done():
	if not get_tree().get_nodes_in_group("Enemies"):
		return true
	return false
