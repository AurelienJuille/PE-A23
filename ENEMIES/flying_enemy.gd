"""
SCRIPT DE L'OBJET FLYING ENEMY
C'est le drone qui se rue vers le joueur en rythme
"""

extends CharacterBody3D

@export var interpolation : Curve
@export var HP : int = 1
var dead = false
var isAttacking = false
var time_elapsed = 0.0
var move_duration = 2
var interpolationSlider :float

var frequency = 4
var pre_anim_beats = 0

var start_pos : Vector3
const DASH_LENGTH : float = .7
var last_pos : Vector3
var destination : Vector3
var speed = 5
var direction : Vector3
var peak_speed = 5.0
var idle_speed = 0.0

var last_executed_beat : int
var death_timer = 1.0
var started = false


func _process(_delta):
	if (visible and 
	not dead and
	GLOBAL.MUSIC_CONTROL.songPositionInBeats != last_executed_beat and
	GLOBAL.MUSIC_CONTROL.songPositionInBeats % frequency == pre_anim_beats):
		last_executed_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats
		attack()


func _physics_process(delta):
	if visible and started:
		if not dead:
			time_elapsed += delta
			interpolationSlider = time_elapsed / move_duration / 2

			var goal_pos = lerp(start_pos, destination, interpolation.sample(interpolationSlider))
			velocity = (goal_pos - global_position) / delta

		
		else:
			death_timer -= delta
			if death_timer < 0:
				queue_free()
			var grav = -9.81
			velocity += Vector3(0, grav * delta, 0)
		move_and_slide()
	


func attack() -> void:
	if visible:
		started = true
		move_duration = 60.0/GLOBAL.MUSIC_CONTROL.bpm
		$AnimationPlayer.speed_scale =  1.0/move_duration
		$AnimationPlayer.play("charge")
		
		time_elapsed = 0
		start_pos = global_position
		direction = (GLOBAL.PLAYER.global_position + Vector3(0,0.2,0) - self.global_position).normalized()
		destination = start_pos + direction * DASH_LENGTH


func _on_area_3d_body_entered(body):
	if body == GLOBAL.PLAYER and not dead:
		GLOBAL.PLAYER.die()


func get_hit():
	HP -= 1
	if HP <= 0:
		dead = true
		$AnimationPlayerSprite.play("crash")
		$crash_sound.play()
		velocity = Vector3((global_position - GLOBAL.PLAYER.global_position).normalized().x * 2, 2, 0)
