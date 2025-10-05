extends CharacterBody2D
signal command_attack

@export var speed = 400
@export var Health = 100
var screen_size
var can_move = true
var attack_order = false
func _ready():
	screen_size = get_viewport_rect().size #get the size of my screen bc the tuto said so




func _process(delta):
	Global.attack_order = self.attack_order
	if Input.is_action_just_pressed("attack_order"):
		attack_order = true
	if Input.is_action_just_released("attack_order"):
		attack_order = false		
	velocity = Vector2.ZERO # The player's movement vector.
	move_and_slide()
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
			# Pas de mouvement → animation arrêtée
			$AnimatedSprite2D.stop()
		if Input.is_action_just_pressed("ui_accept"):
			#die()
			pass
		if Health <=0 : 
			die()
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
	$TimerDeath.wait_time = 5 
	$TimerDeath.start()
func take_damage(damage : int):
	print(Health)
	Health = Health - damage
