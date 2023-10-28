extends AudioStreamPlayer
@export var bpm : float = 92
var measures : int = 4
var secondsPerBeat := 60/bpm
## jai regardé ce tuto https://www.youtube.com/watch?v=_FRiPPbJsFQ 
##je comprends pas tout mais c'etiat super utile
## TO-DO : faire les demi-beats  / quad
var songPosition = 0.0
var songPositionInBeats = 1
var songPositionInSubBeats = 1
var lastReportedBeat = 0
var beatsBeforeStart = 0
var measure = 1
var subMeasure = 1
var subMeasureDivision = 4
var currentSubBeat = 1
#determining how close to the beat an event is
var closest = 0
var timeOffBeat = 0.0
var lastReportedSubBeat = 0

signal currentSubBeatSignal


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body
	play()
	
func _physics_process(delta):
	if playing:
		songPosition = get_playback_position() + AudioServer.get_time_since_last_mix()
		songPosition -= AudioServer.get_output_latency()
		songPositionInBeats = int(floor(songPosition / secondsPerBeat)) + beatsBeforeStart
		songPositionInSubBeats = int(floor(songPosition / (secondsPerBeat / subMeasureDivision))) + (beatsBeforeStart * subMeasureDivision)
		
		#currentSubBeat = (songPositionInSubBeats % subMeasureDivision) + 1
		
		_report_beat()
		
func _report_beat():
	
	if lastReportedBeat < songPositionInBeats:
		if measure > measures:
			measures = 1
		
		#print(currentSubBeat)
		lastReportedBeat = songPositionInBeats
		measure += 1
		#print(measure)
	
	if lastReportedSubBeat < songPositionInSubBeats:
#		print("pos",songPositionInSubBeats)
#		print("last",lastReportedSubBeat)
#		print("current",currentSubBeat)
		lastReportedSubBeat += 1
		currentSubBeatSignal.emit()
		
		
func playWithBeatOffset(beatOffset) :
		beatsBeforeStart = beatOffset
		$StartTimer.wait_time = secondsPerBeat
		$StartTimer.start()
		
func closestBeat(nth):
	closest = int(round((songPosition / secondsPerBeat) / nth) * nth)
	timeOffBeat = abs(closest * secondsPerBeat - songPosition)
	return Vector2(closest,timeOffBeat)
	
func playOnBeat(beat, offset):
	play()
	seek(beat * secondsPerBeat)
	beatsBeforeStart = offset
	measure = beat % measures
	

func onStartTimerTimeout() : 
	songPositionInBeats += 1
	if songPositionInBeats < beatsBeforeStart:
		$StartTimer.start()
	elif songPositionInBeats == beatsBeforeStart:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() - AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop
		
	_report_beat() 	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
