extends CharacterBody3D


const SPEED = .4
const GRAV = 20
var direction = Vector3.RIGHT
var HP = 1


var state = "Walking"
var death_timer = 1.0
var attack_timer = 1.0
var last_executed_beat = -1
var frequency = 8

func _process(_delta):
	if (not state == "Dead" and 
	GLOBAL.MUSIC_CONTROL.songPositionInBeats != last_executed_beat and
	GLOBAL.MUSIC_CONTROL.songPositionInBeats % frequency == 0):
		last_executed_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats
		attack()


func _physics_process(delta):
	if not is_on_floor():
		velocity = Vector3(0, -GRAV * delta, 0)
	
	match state:
		"Walking":
			$Sprite3D/AnimationPlayer.play("Walk")
			if is_on_floor():
				$Sprite3D.scale.x = -1 if direction.x < 0 else 1
				if $RayCastLeft.is_colliding() and not $RayCastRight.is_colliding():
					direction = Vector3.LEFT
				elif not $RayCastLeft.is_colliding() and $RayCastRight.is_colliding():
					direction = Vector3.RIGHT
					
					
				velocity = SPEED * direction
		"Shooting":
			attack_timer -= delta
			if attack_timer < 0:
				state = "Walking"
		"Dead":
			death_timer -= delta
			if death_timer < 0:
				queue_free()
	
	move_and_slide()


func attack():
	velocity = Vector3.ZERO
	$Sprite3D/AnimationPlayer.play("Shoot")
	attack_timer = .8
	state = "Shooting"
	
	
func get_hit():
	HP -= 1
	if HP <= 0:
		state = "Dead"
		$Sprite3D/AnimationPlayer.play("Death")
		

		velocity = Vector3((global_position - GLOBAL.PLAYER.global_position).normalized().x * 2, 7, 0)


func _on_area_3d_body_entered(body):
	if body == GLOBAL.PLAYER:
		GLOBAL.PLAYER.die()
