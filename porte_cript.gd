extends Area2D


# Nom de la scène à charger
@export var scene_to_load: PackedScene

# Signal quand quelque chose entre dans la zone
func _on_area_entered(area):
	if area.is_in_group("player"):
		get_tree().change_scene_to(scene_to_load)

# Connexion du signal
func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
