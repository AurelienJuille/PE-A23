extends Area3D

var player_in = false

func _on_body_entered(body):
	if body == GLOBAL.PLAYER:
		player_in = true


func _on_body_exited(body):
	if body == GLOBAL.PLAYER:
		player_in = false


func _process(delta):
	$Sprite3D.modulate = Color(1,1,0) if player_in else Color(1,1,1)
	if Input.is_action_just_pressed("E"):
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
