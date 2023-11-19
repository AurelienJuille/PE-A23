extends CharacterBody3D

# JUMP VARIABLES
@export var jump_height := .5
@export var jump_up_duration := .25
@export var min_jump_up_duration := .1
var max_fall_speed := 3.0
var grav : float
var jump_strength : float

# SET PHYSICS VARIABLES FROM PARAMETERS
func set_variables() -> void:
	grav = (2 * jump_height) / (jump_up_duration * jump_up_duration)
	jump_strength = (2 * jump_height) / jump_up_duration

  
# RUN VARIABLES
@export var max_speed := 1.5
@export var time_to_full_speed := .2
@export var time_to_stop := .1
var is_jumping : bool

var dash_force = 10.0
var dash_timer_duration = .2
var dash_timer = .0
var dash_cooldown_duration = .5
var dash_cooldown = .0



# ANIMATION VARIABLES
@onready var animation_tree = $AnimationTree
var STATE_MACHINE

func _ready():
	set_variables()
	GLOBAL.PLAYER = self
	STATE_MACHINE = animation_tree.get("parameters/playback")
	get_parent().readJSON()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= grav * delta * (3 if velocity.y > max_fall_speed else 1)
	if is_on_floor():
		velocity.y = .0
	
	
	# MOVEMENT
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
	
	# Dash downward
	if Input.is_action_just_pressed("JUMP") and not is_on_floor():
		velocity.y = -max_fall_speed


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
	
	velocity.x = move_toward(velocity.x, direction.x * max_speed, weight)


var dash_dir
func handle_dash():
	if dash_cooldown <= 0:
		if Input.is_action_just_pressed("DASH"):
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


func die():
	get_tree().reload_current_scene()
	get_node("/root/TEST ROOM/MusicControl").stop()


# SLASH HIT
func _on_slash_area_area_entered(area):
	call_deferred("slash_hit", area)


func slash_hit(area):
	handle_dash()
	if area.get_parent().is_in_group("Enemies") and area.get_parent().has_method("get_hit"):
		if dash_timer > .0:
			area.get_parent().get_hit()



