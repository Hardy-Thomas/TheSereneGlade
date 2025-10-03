extends Area2D


#@export var scene_to_load: PackedScene


#func _ready():
	#connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		#var fade_timer = Timer.new()
		#fade_timer.wait_time = 1
		#fade_timer.one_shot = true
		#add_child(fade_timer)
		#fade_timer.start()
		#fade_timer.timeout.connect(func(): 
		var fade_manager = get_tree().get_first_node_in_group("FadeInOut")
		fade_manager.fade_to_scene("res://cript.tscn")
