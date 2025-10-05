extends FollowerSmarter
class_name Enemy

@export var damage_amount: int = 10
@export var damage_interval: float = 1.0  # délai entre deux coups si le joueur est trop proche


@onready var damage_timer: Timer = $DamageTimer

var target_in_range: Node2D = null

func _ready() -> void:
	if not damage_timer:
		var timer = Timer.new()
		timer.name = "DamageTimer"
		timer.wait_time = damage_interval
		timer.one_shot = false
		timer.autostart = false
		add_child(timer)
		damage_timer = timer
	damage_timer.connect("timeout", Callable(self, "_on_damage_timer_timeout"))

func _on_proximity_body_entered(body: Node2D) -> void:
	# Commence à infliger des dégâts si le player est trop proche
	if body.is_in_group("Player"):
		target_in_range = body
		damage_timer.start()
		anim_sprite.play("attack")

func _on_proximity_body_exited(body: Node2D) -> void:
	if body == target_in_range:
		target_in_range = null
		damage_timer.stop()
		anim_sprite.play("default")

func _on_damage_timer_timeout() -> void:
	if target_in_range and target_in_range.has_method("take_damage"):
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

		target_in_range.take_damage(damage_amount)

func take_damage(amount: int) -> void:
	Health -= amount
	print("Enemy Health:", Health)
	if Health <= 0:
		die()

func die() -> void:
	anim_sprite.play("die")
	queue_free()
