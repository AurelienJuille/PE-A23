extends Node

@export var start_beats_left : int = 30
var beats_left : int
var current_beat : int


func _ready():
	GLOBAL.GAME_TIMER = self


func init():
	beats_left = start_beats_left
	GLOBAL.MUSIC_CONTROL.currentSubBeatSignal.connect(_on_music_control_current_sub_beat_signal)
	current_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats


func _on_music_control_current_sub_beat_signal():
	if GLOBAL.MUSIC_CONTROL.songPositionInBeats != current_beat:
		current_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats
		beats_left -= 1
		$CanvasLayer/Label.text = str(beats_left)
		if beats_left <= 0:
			GLOBAL.PLAYER.die()
			
func add_beat(value : int) -> void:
	beats_left += value
	$CanvasLayer/Label.text = str(beats_left)
	
