extends Camera3D

var timer = .0
var target = Vector3.ZERO

func _process(delta):
	timer -= delta
	var player_pos = get_parent().global_position
	if timer <= .0:
		target = Vector3(randf_range(-2, 2), randf_range(.5, 1.5) * 5, 10)
		timer = 3.0
	
	position = lerp(position, target, .05)
	look_at(player_pos)
