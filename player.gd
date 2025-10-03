extends CharacterBody2D


@export var speed = 400 # HERE we set up the speed variable and it can be changed afterward 
var screen_size # Size of the game window.
func _ready():
	screen_size = get_viewport_rect().size #get the size of my screen bc the tuto said so


#code that i stole from the tutorial and changed
func _process(delta):
	velocity = Vector2.ZERO # The player's movement vector.
	move_and_slide()
	
	# --- Déplacements ---
	if Input.is_action_pressed("move_right"):
		SoundManager.play_sound("walk")
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		SoundManager.play_sound("walk")
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		SoundManager.play_sound("walk")
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		SoundManager.play_sound("walk")
		velocity.y -= 1

	# --- Normalisation et mouvement ---
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)

		# --- Choix de l'animation en fonction de la direction ---
		if abs(velocity.x) > abs(velocity.y): 
			# Mouvement horizontal prioritaire
			if velocity.x > 0:
				$AnimatedSprite2D.animation = "RightWalk"
			else:
				$AnimatedSprite2D.animation = "LeftWalk"
		else:
			# Mouvement vertical prioritaire
			if velocity.y > 0:
				$AnimatedSprite2D.animation = "DownWalk"
			else:
				$AnimatedSprite2D.animation = "UpWalk"

		$AnimatedSprite2D.play()
	else:
		# Pas de mouvement → animation arrêtée
		$AnimatedSprite2D.stop()
