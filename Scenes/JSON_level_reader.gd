extends Node3D

@export_file("*json") var json_file_path
@export_file("*tscn") var next_level_file_path
var content
var file_read = false
var last_beat_executed : String

# ENEMIES TO SPAWN 
@export var bonus_scene: PackedScene
@export var flying_enemy_scene: PackedScene
var enemy_dict = {
	"flying": []
}

func readJSON():
	var json_as_text = FileAccess.get_file_as_string(json_file_path)
	content = JSON.parse_string(json_as_text)
	file_read = true


func _ready():
	GLOBAL.MUSIC_CONTROL.currentSubBeatSignal.connect(_on_music_control_current_sub_beat_signal)
	GLOBAL.SPAWNER = self


func _on_music_control_current_sub_beat_signal() -> bool:
	if file_read:
		var beat = str(GLOBAL.MUSIC_CONTROL.songPositionInBeats)
		if content.has(beat) and beat != last_beat_executed:
			last_beat_executed = beat
			var info = content[beat]
			if info.has("end"):
				get_tree().change_scene_to_file("res://Scenes/WinScene.tscn")
			if info.has("spawn"):
				for ennemy in info["spawn"]:
					var t = str(ennemy["type"])
					var child_scene = bonus_scene if t == "bonus" else flying_enemy_scene if t == "flying" else flying_enemy_scene
					
					var child = child_scene.instantiate()
					if t != "bonus":
						enemy_dict[ennemy["type"]].append(child)
					else:
						var l = str(ennemy["level"])
						child.beat_bonus = child.BONUS["level_" + l]
					child.visible = false
					$ENEMIES.add_child(child)
					var spawner_number = ennemy["spawner"]
					child.global_position = $SPAWNERS.get_child(spawner_number - 1).global_position
					print(child.global_position)
					child.visible = true
			
			if info.has("frequency"):
				for new_frequency in info["frequency"]:
					for enemy in enemy_dict[new_frequency["type"]]:
						enemy.frequency = new_frequency["value"]
			return true
		return true
	else:
		return false
	
