extends CharacterBody3D

# JUMP VARIABLES
@export var jump_height := .45
@export var jump_up_duration := .3
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
var gravity: float = 2


# ANIMATION VARIABLES
@onready var animation_tree = $AnimationTree
var STATE_MACHINE

func _ready():
	set_variables()
	STATE_MACHINE = animation_tree.get("parameters/playback")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= grav * delta
	if is_on_floor():
		velocity.y = .0
	
	handle_jump()
	handle_run(delta)
	
	move_and_slide()
	animation()


func animation():
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
	if direction.x != 0:
		$Sprite3D.scale.x = sign(direction.x)
	velocity.x = move_toward(velocity.x, direction.x * max_speed, (1.0 if is_on_floor() else .33) * max_speed * delta / (time_to_full_speed if abs(direction.x) > abs(velocity.x) else time_to_stop))
#	velocity.z = move_toward(velocity.z, direction.z * max_speed, (1.0 if is_on_floor() else .33) * max_speed * delta / (time_to_full_speed if abs(direction.z) > abs(velocity.z) else time_to_stop))
	
	
func die():
#	self.visible = false
	print("You Lost")
	get_tree().reload_current_scene()
	get_node("/root/TEST ROOM/MusicControl").stop()


func _on_area_3d_area_entered(area):
	if area.get_parent().is_in_group("Enemies"):
		die()


