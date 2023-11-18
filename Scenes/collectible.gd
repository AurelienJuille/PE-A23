extends Node3D

enum BONUS {
	level_1 = 5,
	level_2 = 10,
	level_3 = 20
}
@export var beat_bonus : BONUS

@export_file("*.mp3") var sound_1: String
@export_file("*.mp3") var sound_2: String
@export_file("*.mp3") var sound_3: String

func _on_area_body_entered(body):
	if body == GLOBAL.PLAYER and visible:
		visible = false
		GLOBAL.GAME_TIMER.add_beat(beat_bonus)
		var mp3 = load(sound_1)
		$AudioStreamPlayer3D.stream = mp3
		$AudioStreamPlayer3D.play()
		await $AudioStreamPlayer3D.finished
		self.queue_free()
