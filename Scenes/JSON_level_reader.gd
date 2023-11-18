extends Node3D

@export_file("*json") var json_file_path
var content
var file_read = false

# ENEMIES TO SPAWN
@export var flying_ennemy: PackedScene
var enemy_dict = {
	"flying": []
}

func readJSON():
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	content = JSON.parse_string(content_as_text)
	file_read = true
	

func _ready():
	GLOBAL.MUSIC_CONTROL.currentSubBeatSignal.connect(_on_music_control_current_sub_beat_signal)
	GLOBAL.SPAWNER = self

func _process(delta):
	if Input.is_action_just_pressed("P"):
		readJSON()
		


func _on_music_control_current_sub_beat_signal() -> bool:
	if file_read:
		for beat in content:
			if GLOBAL.MUSIC_CONTROL.songPositionInBeats == int(beat):
				if beat["spawn"]:
					for ennemy in beat["spawn"]:
						var child = flying_ennemy if ennemy["type"] == "flying" else null
						enemy_dict[ennemy["type"]].append(child)
						
						child.visible = false
						child.instantiate()
						$ENEMIES.add_child(child)
						child.global_position = ennemy["position"]
						child.visible = true
				if beat["frequency"]:
					for new_frequency in beat["frequency"]:
						for enemy in enemy_dict[new_frequency["type"]]:
							enemy.frequency = new_frequency["value"]
				return true
		return true
	else:
		return false
