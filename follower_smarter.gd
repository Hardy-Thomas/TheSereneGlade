extends Npc
class_name FollowerSmarter

@export var follow_player_when_near := true
@export var follow_distance := 4.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: Node2D = null
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction := Vector2.ZERO
var idle := false
var speed2 = 100



func _ready() -> void:
	await get_tree().process_frame
	_play_idle_animation(Vector2.ZERO)
	is_roaming = true
	is_chatting = false
	is_following = true
	start_pos = position
	idle = false
	targeting()

func _process(delta):
	if velocity != Vector2.ZERO:
		last_direction = velocity.normalized()
		_play_walk_animation(last_direction)
	elif idle:
		_play_idle_animation(last_direction)

	if Input.is_action_just_pressed("ui_accept"):
		$dialogue.start()
		is_roaming = false
		is_chatting = true
	if Input.is_action_just_pressed("clicked") && is_mouse:
		$dialogue.start()
		is_roaming =false
		is_chatting = true

func _physics_process(delta):
	if player and is_following:
		if not is_instance_valid(target):
			targeting()
			return

		# Met à jour dynamiquement la position cible
		var target_pos = target.global_position
		if nav_agent.target_position != target_pos:
			nav_agent.target_position = target_pos

		# Si le chemin est terminé (arrivé proche du joueur)
		if nav_agent.is_navigation_finished() or global_position.distance_to(target_pos) < follow_distance:
			velocity = Vector2.ZERO
			move_and_slide()
			return

		# Calcule la prochaine position et direction
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed2

		# Déplace le NPC selon la vélocité
		move_and_slide()  # IMPORTANT pour Godot 4
	else:
		velocity = Vector2.ZERO
		move_and_slide()

# --- Gestion du ciblage ---
func targeting():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() == 0:
		target = null
		return
	target = players[0]
	player = target

# --- Animation ---

func _play_walk_animation(direction: Vector2) -> void:
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

func _play_idle_animation(direction: Vector2) -> void:
	$AnimatedSprite2D2.play("idle")
func _on_TimerIdle_timeout() -> void:
	idle = true
	_play_idle_animation(last_direction)

# --- Zones de proximité et dialogue ---
func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_in_chat_zone = true
		is_following = false

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_chat_zone = false
		is_following = false
		emit_signal("dialogue_exited")

func _on_proximity_too_close_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_following = false

func _on_proximity_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		is_following = follow_player_when_near

func _on_proximity_too_close_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_following = follow_player_when_near


func _on_chat_detection_mouse_entered() -> void:
	is_mouse = true
	

func _on_chat_detection_mouse_exited() -> void:
	is_mouse = false
