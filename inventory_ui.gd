extends CanvasLayer

@onready var item_list = $Panel/VBoxContainer
var is_open = false

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_inventory"):
		toggle_inventory()

func toggle_inventory():
	is_open = !is_open
	if is_open:
		show()
		update_inventory()
	else:
		hide()

func update_inventory():
	for child in item_list.get_children():
		child.queue_free()

	for item_name in Inventory.inventory:
		var label = Label.new()
		label.text = item_name
		item_list.add_child(label)
