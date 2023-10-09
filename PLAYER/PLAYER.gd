extends CharacterBody3D

# JUMP VARIABLES
@export var jump_height := 2.5
@export var half_jump_up_duration := .3
var max_fall_speed := 500.0
var grav : float
var jump_strength : float

# SET PHYSICS VARIABLES FROM PARAMETERS
func set_variables() -> void:
	grav = (2 * jump_height) / (half_jump_up_duration * half_jump_up_duration)
	jump_strength = (2 * jump_height) / half_jump_up_duration


# RUN VARIABLES
@export var max_speed := 1.5
@export var time_to_full_speed := .2
@export var time_to_stop := .1



func _ready():
	set_variables()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= grav * delta

	# Handle Jump.
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = jump_strength

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction.x != 0:
		$Sprite3D.scale.x = sign(direction.x)
	velocity.x = move_toward(velocity.x, direction.x * max_speed, (1.0 if is_on_floor() else .33) * max_speed * delta / (time_to_full_speed if abs(direction.x) > abs(velocity.x) else time_to_stop))
#	velocity.z = move_toward(velocity.z, direction.z * max_speed, (1.0 if is_on_floor() else .33) * max_speed * delta / (time_to_full_speed if abs(direction.z) > abs(velocity.z) else time_to_stop))
	if velocity.x == 0:
		$Sprite3D.play("idle")
	else:
		$Sprite3D.play("run")
	move_and_slide()
