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
var idle_speed = 0.0

var last_executed_beat : int


func _process(delta):
	if GLOBAL.MUSIC_CONTROL.songPositionInBeats % frequency == 0 and GLOBAL.MUSIC_CONTROL.songPositionInBeats != last_executed_beat:
		last_executed_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats
		attack()


func _physics_process(delta):
	
	time_elapsed += delta
	interpolationSlider = time_elapsed / move_duration / 2

	speed = lerp(idle_speed,peak_speed,interpolation.sample(interpolationSlider))
	velocity = speed * direction
	move_and_slide()
		
	
	
func attack() -> void:
	move_duration = 60.0/GLOBAL.MUSIC_CONTROL.bpm
	$AnimationPlayer.speed_scale =  1.0/move_duration
	$AnimationPlayer.play("charge")
#	await $AnimationPlayer.animation_finished
	time_elapsed = 0
	destination = GLOBAL.PLAYER.global_position + Vector3(0,0.2,0)
	direction = (destination - self.global_position).normalized()
	
	
#    start = self.position


func _on_area_3d_body_entered(body):
	if body == GLOBAL.PLAYER:
		GLOBAL.PLAYER.die()
	pass # Replace with function body.
