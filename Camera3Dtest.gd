extends Camera3D

var timer = .0
var target = Vector3.ZERO
var offset = Vector3.ZERO

func _physics_process(delta):
	var player_pos = get_parent().get_node("PLAYER").global_position
	offset = lerp(offset, target, .05)
	position = Vector3(player_pos.x, 0, player_pos.z) + offset
	look_at(Vector3(player_pos.x, 0.1, player_pos.z))

	timer -= delta
	if timer <= .0:
		target = Vector3(randf_range(-.2, .2), randf_range(.3, .5), .8)
		timer = 3.0
	
