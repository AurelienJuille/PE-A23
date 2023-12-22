"""
SCRIPT DE L'OBJET JOUEUR
C'est le personnage controlé grâce au clavier et à la souris
"""

extends CharacterBody3D

# JUMP VARIABLES
@export var jump_height := .5
@export var jump_up_duration := .25
@export var min_jump_up_duration := .1
var max_fall_speed := 3.0
var grav : float
var jump_strength : float

# SET PHYSICS VARIABLES FROM PARAMETERS
# Cette fonction permet d'initialiser les variables "grav" et "jump_strength" de sorte que 
# le saut du joueur atteigne la hauteur "jump_height" en "jump_up_duration" secondes
func set_variables() -> void:
	grav = (2 * jump_height) / (jump_up_duration * jump_up_duration)
	jump_strength = (2 * jump_height) / jump_up_duration

  
# RUN VARIABLES
@export var max_speed := 1.5
@export var time_to_full_speed := .2
@export var time_to_stop := .1
var is_jumping : bool

# DASH VARIABLES (variables associées à l'action de dash, quand on fait un click gauche)
var dash_force = 11.0
var dash_timer_duration = .2
var dash_timer = .0
var dash_cooldown_duration = .5
var dash_cooldown = .0


# ANIMATION VARIABLES
@onready var animation_tree = $AnimationTree
var STATE_MACHINE

# INVINCIBILITY
var invincible = false
func toggle_invincibility():
	if OS.is_debug_build():
		invincible = not invincible
		print("SET INVINCIBILITY TO : ", invincible)


# En godot, la fonction _ready() est appelée une fois lorsque la scène est instanciée. On s'en sert pour initialiser le comportement d'une scène
func _ready():
	$Slash/Slash_Area.monitoring = false
	set_variables()
	GLOBAL.PLAYER = self
	STATE_MACHINE = animation_tree.get("parameters/playback")
	# Une fois que le personnage jouable est instancié, il lance le niveau en appelant sa fonction readJson()
	get_parent().readJSON()


# En godot, la fonction _physics_process(delta) est appelée à chaque frame du moteur physique du jeu. 
# L'argument delta représente le temps écoulé depuis le dernier appel de _physics_process() en secondes.
# On se sert de cette fonction pour coder le comportement du personnage jouable
func _physics_process(delta):
	# Permet de rendre le personnage invincible pour débuger les niveaux. Cette fonctionnalité est retirée dans le build final
	if Input.is_action_just_pressed("toggle_invincibility"):
		toggle_invincibility()
	
	# is_on_floor() retourne vrai lorsque le joueur est en collision avec un objet physique en dessous de lui (le sol)
	if not is_on_floor():
		# Le vecteur tridimensionnel velocity correspond à la vitesse du joueur
		velocity.y -= grav * delta * (3 if velocity.y > max_fall_speed else 1)
	if is_on_floor():
		velocity.y = .0
	
	
	# MOVEMENT DU JOUEUR
	handle_dash()
	if dash_cooldown > 0:
		dash_cooldown -= delta
	
	if dash_timer > 0:
		$Slash.visible = true
		dash_timer -= delta
	else:
		$Slash.visible = false
		handle_jump()
		handle_run(delta)
	
	velocity.z = 0
	move_and_slide()
	animation()
	arrows_to_bonus()


# Cette fonction gère l'animation du dessin du personnage en fonction de ses mouvements
func animation():
	if velocity.x != 0:
		$Sprite3D.scale.x = sign(velocity.x)
	
	if dash_timer > 0:
		STATE_MACHINE.travel("Attack_side")
		return
	
	if is_on_floor():
		if velocity.x == 0:
			STATE_MACHINE.travel("Idle")
		else:
			STATE_MACHINE.travel("Run")
	else:
#		was_on_floor = false
		if velocity.y > 0:
			STATE_MACHINE.travel("Jump_up")
		else:
			STATE_MACHINE.travel("Jump_down")



# Cette fonction gère les sauts du joueur
var was_on_floor = true # Utile pour le coyote time
func handle_jump():
	# Press Space Buffer
	if Input.is_action_just_pressed("JUMP"):
		$JumpBufferTimer.start()
	
	if was_on_floor and not is_on_floor():
		$CoyoteJumpTimer.start()
		was_on_floor = false
	
	# Normal Jump
	if (Input.is_action_just_pressed("JUMP") or $JumpBufferTimer.time_left > .0) and (is_on_floor() or $CoyoteJumpTimer.time_left > .0):
		is_jumping = true
		velocity.y = jump_strength
		$HollowKnightJumpTimer.start(min_jump_up_duration)
	
	# Hollow Knight Jump
	elif not Input.is_action_pressed("JUMP") and is_jumping and $HollowKnightJumpTimer.time_left == .0 and velocity.y > 0:
		velocity.y *= .3
		is_jumping = false


# Cette fonction gère les déplacements au sol du joueur
func handle_run(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var weight = max_speed * delta

	if not is_on_floor():
		weight *= .33
		
	if abs(direction.x) > abs(velocity.x):
		weight /= time_to_full_speed
	else:
		weight /= time_to_stop
	
	if abs(velocity.x) > max_speed:
		weight *= 5
	
	velocity.x = move_toward(velocity.x, direction.x * max_speed, weight*3)


# Cette fonction gère les dash du joueur (attaque lors d'un click de souris)
var dash_dir
func handle_dash():
	if dash_cooldown <= 0:
		if Input.is_action_just_pressed("DASH"):
			$whoosh_sound.pitch_scale = randf_range(.9,1.1)
			$whoosh_sound.play()
			$Slash/Slash_Area.monitoring = true
			#DASH MECANIC
			var position2D = get_viewport().get_mouse_position()
			var dropPlane  = Plane(Vector3(0, 0, 1), 0)
			var position3D = dropPlane.intersects_ray($Camera3D.project_ray_origin(position2D),$Camera3D.project_ray_normal(position2D))
			dash_dir = (position3D - Vector3(0, .12, 0) - global_position).normalized()
			dash_timer = dash_timer_duration
			dash_cooldown = dash_cooldown_duration
			
			#SLASH ANIMATION
			$Slash.rotation = Vector3.ZERO
			var angle = dash_dir.angle_to(Vector3(1,0,0))
			if dash_dir.y <= 0:
				angle = 2 * PI - angle
			$Slash.rotate(Vector3(0,0,1), angle)
			$Slash/Slash_Sprite.flip_v = dash_dir.x < 0
	elif dash_timer > 0:
		var speed = (dash_timer / dash_timer_duration) * dash_force
		velocity = dash_dir * speed
	else:
		$Slash/Slash_Area.monitoring = false


# Lorsque le joueur est touché par un enemi, renvoie vers l'écran de game over
func die():
	if not invincible:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/LoseScene.tscn")


# SLASH HIT
# Lorsque la hitbox de l'épée du joueur entre en collision avec un ennemi, on appelle la fonction get_hit() de ce dernier
func _on_slash_area_area_entered(area):
	if area.get_parent().is_in_group("Enemies") and area.get_parent().has_method("get_hit"):
		area.get_parent().get_hit()


# Cette fonction dirige la flèche autour du personnage vers le bonus le plus proche, ou la cache lorsqu'aucun bonus n'est disponible
func arrows_to_bonus():
	var min_dist = PI * 1000
	var min_dist_pos = Vector3.ZERO
	for bonus in GLOBAL.SPAWNER.get_node("BONUS").get_children():
		if bonus.visible and (bonus.global_position - global_position).length() < min_dist:
			min_dist = (bonus.global_position - global_position).length()
			min_dist_pos = bonus.global_position
			
	
	if (min_dist != PI * 1000) and (min_dist > 0.8):
		$ARROWS.visible = true
		var bonus_dir = (min_dist_pos - global_position).normalized()
		$ARROWS.rotation = Vector3.ZERO
		var angle = bonus_dir.angle_to(Vector3(1,0,0))
		if bonus_dir.y <= 0:
			angle = 2 * PI - angle
		$ARROWS.rotate(Vector3(0,0,1), angle)
	else:
		$ARROWS.visible = false
	
	
	
	
	
	
	
	
	
	
	
