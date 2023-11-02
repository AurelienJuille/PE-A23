extends Camera3D

var timer = .0
var target = Vector3.ZERO
var cameraTransition = Vector3.ZERO
@export var yPosition : float
@export var yRotation : float
@export var height : float
@export var distanceFromPlayer : float

func _physics_process(delta):
#	var cameraPositionOffset = Vector3(0,height,distanceFromPlayer)
#	var player_pos = get_parent().get_node("PLAYER").global_position
#	cameraTransition = lerp(cameraTransition, target, .3)
#	position = Vector3(player_pos.x, yPosition, player_pos.z) + cameraTransition + cameraPositionOffset
#	look_at(Vector3(player_pos.x, yRotation, player_pos.z))	

	timer -= delta
	
#	if timer <= .0:
#		target = Vector3(randf_range(-0, 0), randf_range(0, 0), .8)
#		timer = 3.0
	
