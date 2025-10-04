# Ally.gd
extends Npc
class_name Ally

@export var follow_player_when_near := true
@export var follow_distance := 4.0

var last_direction := Vector2.ZERO
var idle := false

func _ready() -> void:
	is_roaming = true
	is_chatting = false
	is_following = false
	start_pos = position
	idle = false

func _process(delta: float) -> void:
	if follow_player_when_near and player and is_following:
		var v = player.global_position - global_position

		if v.length() > follow_distance:
			# déplacement
			var direction = v.normalized()
			position += direction * speed * delta
			last_direction = direction
			idle = false
			$TimerIdle.stop()
			_play_walk_animation(direction)
		else:
			# proche → plus de déplacement
			if not idle:
				$TimerIdle.start()  # déclenche le compte à rebours avant idle
	else:
		# pas de suivi
		if not idle:
			$TimerIdle.start()

func _play_walk_animation(direction: Vector2) -> void:
	# On compare la direction dominante
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$AnimatedSprite2D2.play("right_walk")
		else:
			$AnimatedSprite2D2.play("left_walk")
	else:
		if direction.y > 0:
			$AnimatedSprite2D2.play("front_walk")
		else:
			$AnimatedSprite2D2.play("back_walk")

# Quand TimerIdle expire, passe en anim "idle"
func _on_TimerIdle_timeout() -> void:
	idle = true
	$AnimatedSprite2D2.play("idle")

func _on_chat_detection_body_entered(body: Node2D) -> void:
	return

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_chat_zone = false
		is_following = false
		emit_signal("dialogue_exited")





func _on_proximity_too_close_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_chat_zone = false
		is_following = false
		emit_signal("dialogue_exited")


func _on_proximity_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_in_chat_zone = true
		is_following = follow_player_when_near


func _on_proximity_too_close_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_in_chat_zone = true
		is_following = follow_player_when_near
