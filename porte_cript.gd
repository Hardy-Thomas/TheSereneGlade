extends Area2D


@export var scene_to_load: PackedScene


#func _ready():
	#connect("area_entered", Callable(self, "_on_area_entered"))


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Players"):
		get_tree().change_scene_to(scene_to_load)
