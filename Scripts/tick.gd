extends AudioStreamPlayer
var subBeatSignal : Signal
#var musicControlNode: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	#musicControlNode = get_parent().get_node("MusicControl")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	$MusicControl.currentSubBeatSignal.connect(playSound())
	pass
	
#func playSound():
	


func _on_music_control_current_sub_beat_signal():
	#print(musicControlNode.lastReportedSubBeat)
	if (GLOBAL.MUSIC_CONTROL.lastReportedSubBeat % 4 + 1) == 1:
		play()
	pass # Replace with function body.
