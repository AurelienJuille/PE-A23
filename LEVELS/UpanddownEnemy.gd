extends MeshInstance3D
@onready var musicControlNode: AudioStreamPlayer = get_node("/root/TEST ROOM/MusicControl")
var subBeatSignal : Signal
var moveSpeed = 0.7
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_music_control_current_sub_beat_signal():
	if (musicControlNode.lastReportedBeat % 2 + 1) == 2:
		moveUp();
	elif (musicControlNode.lastReportedBeat % 2 + 1) == 1:
		moveDown()
	pass # Replace with function body.
	
func moveUp():
	position.y = -0.5
func moveDown():
	position.y = 0
		
