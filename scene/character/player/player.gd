extends CharacterBody2D
signal command_attack

@export var speed = 400
@export var Health = 100
var screen_size
var can_move = true
var attack_order = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if Input.is_action_just_pressed("clicked"):
		die()
	# --- Activation mode attaque ---
	if Input.is_action_just_pressed("attack_order"):
		attack_order = true
		print("Mode attaque :", attack_order)
		_start_attack_mode()

	# --- Déplacements ---
	velocity = Vector2.ZERO
	if can_move:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		_update_animation()
	else:
		$AnimatedSprite2D.stop()

	if Health <= 0:
		print('full dead')
		die()

func _update_animation():
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "RightWalk"
		else:
			$AnimatedSprite2D.animation = "LeftWalk"
	else:
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "DownWalk"
		else:
			$AnimatedSprite2D.animation = "UpWalk"
	$AnimatedSprite2D.play()

func die() -> void:

	#$AnimatedSprite2D.animation = "die"

	can_move = false
	$TimerDeath.wait_time = 4
	
	$TimerDeath.start()
	await $TimerDeath.timeout
	get_tree().change_scene_to_file("res://scene/levels/title/title_scene.tscn")

func take_damage(damage : int):
	Health -= damage
	print("Player Health:", Health)

# --- Mode attaque pour les followers ---
func _start_attack_mode():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() == 0:
		return

	var target_enemy = enemies[0]  # On choisit le premier ennemi visible
	print("Cible attaquée :", target_enemy.name)

	# On active le mode attaque pour tous les followers
	var followers = get_tree().get_nodes_in_group("Followers")
	for f in followers:
		if f.has_method("set_attack_mode"):
			f.set_attack_mode(true)
			f.target = target_enemy  # assigner la cible directement


func _on_timer_death_timeout() -> void:
	pass # Replace with function body.
