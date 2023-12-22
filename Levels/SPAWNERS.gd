extends Node3D

var warning_scene = preload("res://Scenes/warning.tscn")
var spawn_list = []

func spawn(child, spawner_number: int, instant = false):
	child.global_position = get_child(spawner_number - 1).global_position
	if instant:
		child.visible = true
	else:
		var warning = warning_scene.instantiate()
		get_child(spawner_number - 1).add_child(warning)
		spawn_list.append({"enemy": child, "timer": 1.0, "started": false})


func _physics_process(delta):
	for element in spawn_list:
		element["timer"] -= delta
		if element["timer"] <= 0 and not element["started"]:
			start_enemy_behaviour(element["enemy"])
			element["started"] = true
			

func start_enemy_behaviour(enemy):
	enemy.visible = true
