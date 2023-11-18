extends CharacterBody3D

@export var interpolation : Curve
var isAttacking = false
var time_elapsed = 0.0
var move_duration = 2
var interpolationSlider :float

var frequency = 2

var start : Vector3
var destination : Vector3
var speed = 5
var direction : Vector3
var peak_speed = 5.0
var idle_speed = 0.2


func _ready():
	
	
	pass

func _process(delta):
	if GLOBAL.MUSIC_CONTROL.songPositionInBeats % frequency == 0:
		attack()
	
	if Input.is_action_just_pressed("ui_page_down"):
		attack()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	time_elapsed += delta
	interpolationSlider = time_elapsed / move_duration
#		self.position = lerp(start,destination,interpolation.sample(interpolationSlider))

	speed = lerp(idle_speed,peak_speed,interpolation.sample(interpolationSlider))
	velocity = speed * direction
	move_and_slide()
		
	
	
func attack() -> void:
	print("start")
	move_duration = 60.0/GLOBAL.MUSIC_CONTROL.bpm
	$AnimationPlayer.speed_scale =  1.0/move_duration
	$AnimationPlayer.play("charge")
	destination = GLOBAL.PLAYER.global_position
	await $AnimationPlayer.animation_finished
	print("now")
	time_elapsed = 0
	direction = (destination - self.global_position).normalized()
	
	
#	start = self.position
