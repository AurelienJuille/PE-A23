extends Node3D

@export_file("*json") var json_file_path
var content
var file_read = false
var last_beat_executed : String

# ENEMIES TO SPAWN
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
			if info.has("spawn"):
				for ennemy in info["spawn"]:
					var child_scene = flying_enemy_scene if str(ennemy["type"]) == "flying" else "Mettre la scène correspondante à l'ennemi"
					
					var child = child_scene.instantiate()
					enemy_dict[ennemy["type"]].append(child)
					child.visible = false
					$ENEMIES.add_child(child)
					var pos = ennemy["position"]
					child.global_position = Vector3(pos[0], pos[1], pos[2])
					child.visible = true
			
			if info.has("frequency"):
				for new_frequency in info["frequency"]:
					for enemy in enemy_dict[new_frequency["type"]]:
						enemy.frequency = new_frequency["value"]
			return true
		return true
	else:
		return false
	
	
