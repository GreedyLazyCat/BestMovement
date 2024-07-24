class_name InventoryHandler
extends Node

var items: Dictionary

signal contents_changed

func delete_item(item_name: String):
	for item in items.keys():
		if item.item_name == item_name:
			items.erase(item)
	contents_changed.emit()

func has_item(item_name: String) -> bool:
	for item in items.keys():
		if item.item_name == item_name:
			return true
	return false

func add_item(item: Item):
	if item in items.keys():
		items[item] += 1
	else:
		items[item] = 1
	contents_changed.emit()

func get_items_str() -> String:
	if items.is_empty():
		return ''
	var result = ''
	for item in items.keys():
		result += item.item_display_name + ': ' + str(items[item]) + '\n'
	return result
