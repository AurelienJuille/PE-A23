extends MeshInstance3D
@onready var musicControlNode: AudioStreamPlayer = get_tree().root.get_child(0).get_node("MusicControl")
var subBeatSignal : Signal
@export var moveDuration : float
@export var initialPosition : Vector3 = self.position
@export var relativeEndPosition : Vector3
var endPosition : Vector3

@export var triggerOnBeat : int
@export var triggerOnSubBeat : int
@export var interpolation : Curve
var interpolationSlider = 0.0
var isMoving : bool
var timeElapsed : float


# Called when the node enters the scene tree for the first time.
func _ready():
	position = initialPosition
	endPosition = initialPosition + relativeEndPosition
	timeElapsed = 0
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(interpolationSlider)
	if (isMoving):
		timeElapsed += delta
		interpolationSlider = timeElapsed / moveDuration
		self.position = lerp(initialPosition, endPosition, interpolation.sample(interpolationSlider))
		if interpolationSlider >= 1 :
			isMoving = false
			timeElapsed = 0
	pass


func _on_music_control_current_sub_beat_signal():
	if(musicControlNode.lastReportedBeat == triggerOnBeat || musicControlNode.lastReportedSubBeat == triggerOnSubBeat):
		#print("last reported beat: ", musicControlNode.lastReportedBeat)
		isMoving = true
	pass # Replace with function body.

		
