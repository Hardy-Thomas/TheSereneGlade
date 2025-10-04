extends Node

var inventory: Array = []

func add_item(item_name: String):
	if not has_item(item_name):
		inventory.append(item_name)
		print(item_name, " add to inventory")
	else:
		print(item_name, " already in inventory")

func remove_item(item_name: String):
	if has_item(item_name):
		inventory.erase(item_name)
		print(item_name, " out of inventory")

func has_item(item_name: String) -> bool:
	return item_name in inventory
