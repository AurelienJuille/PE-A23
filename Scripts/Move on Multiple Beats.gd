extends MeshInstance3D
#@onready var musicControlNode: AudioStreamPlayer = get_tree().root.get_child(0).get_node("MusicControl")
var subBeatSignal : Signal
@export var positions : Array[Vector3]
@export var moveFromBeatToBeat: Array[Vector2]
var moveDurations : Array[float]
var moveDuration : float
@export var initialPosition : Vector3 = self.position
@export var relativeEndPosition : Vector3
var endPosition : Vector3

@export var triggerOnBeat : int
@export var triggerOnSubBeat : int
@export var interpolation : Curve
var interpolationSlider = 0.0
var isMoving : bool
var timeElapsed : float
var step : int

func init():
	GLOBAL.MUSIC_CONTROL.currentSubBeatSignal.connect(_on_music_control_current_sub_beat_signal)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(moveFromBeatToBeat.size()-1):
		moveDurations.append((float(moveFromBeatToBeat[i][1] - moveFromBeatToBeat[i][0])))
	#position = initialPosition
	#endPosition = initialPosition + relativeEndPosition
	timeElapsed = 0
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if (isMoving):
		timeElapsed += delta
		interpolationSlider = timeElapsed / moveDuration
		self.position = lerp(initialPosition, endPosition, interpolation.sample(interpolationSlider))
		if interpolationSlider >= 1 :
			isMoving = false
			timeElapsed = 0
	pass


func _on_music_control_current_sub_beat_signal():
	if(GLOBAL.MUSIC_CONTROL.lastReportedBeat == moveFromBeatToBeat[self.step][0]):
		moveToPoint()
	pass # Replace with function body.
	
	
func moveToPoint():
	if(step + 1 < positions.size()):
		initialPosition = positions[step]
		endPosition = positions[step+1] #what happens when we run out of steps?
		moveDuration = moveDurations[step]
		isMoving = true
		step += 1
	
func moveUp():
	position.y = -0.5
func moveDown():
	position.y = 0
		
