extends Node3D

@export var bonus_scene: PackedScene

func _ready():
	GLOBAL.COLLECTIBLES = self
	


func spawn_bonus(level : int, spawn_position : Vector2):
	var bonus = bonus_scene.instantiate()
	bonus.beat_bonus = bonus.BONUS.level_1 if level == 1 else bonus.BONUS.level_2 if level == 2 else bonus.BONUS.level_3
	bonus.visible = false
	add_child(bonus)
	bonus.global_position = Vector3(spawn_position.x, spawn_position.y, 0)
	bonus.visible = true
