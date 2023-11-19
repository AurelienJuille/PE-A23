extends AudioStreamPlayer
@export var bpm : float = 160
var measures : int = 4
var secondsPerBeat := 60/bpm
## jai regardé ce tuto https://www.youtube.com/watch?v=_FRiPPbJsFQ 
##je comprends pas tout mais c'etiat super utile
## TO-DO : faire les demi-beats  / quad
var songPosition = 0.0
var songPositionInBeats = 0
var songPositionInSubBeats = 0
var lastReportedBeat = 0
var beatsBeforeStart = 0
var measure = 0
var subMeasure = 0
var subMeasureDivision = 4
var currentSubBeat = 0
#determining how close to the beat an event is
var closest = 0
var timeOffBeat = 0.0
var lastReportedSubBeat = 0

signal currentSubBeatSignal


# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBAL.MUSIC_CONTROL = self
	get_tree().call_group("Enemies", "init")
	play()
	
func _physics_process(_delta):
	if playing:
		songPosition = get_playback_position() + AudioServer.get_time_since_last_mix()
		songPosition -= AudioServer.get_output_latency()
		songPositionInBeats = int(floor(songPosition / secondsPerBeat)) + beatsBeforeStart
		songPositionInSubBeats = int(floor(songPosition / (secondsPerBeat / subMeasureDivision))) + (beatsBeforeStart * subMeasureDivision)
		
		currentSubBeat = (songPositionInSubBeats % subMeasureDivision)
		
		_report_beat()
		
func _report_beat():
	if lastReportedBeat < songPositionInBeats:
		if measure > measures:
			measures = 1
		
		lastReportedBeat = songPositionInBeats
		measure += 1
	
	if lastReportedSubBeat < songPositionInSubBeats:
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
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_start_timer_timeout():
	songPositionInBeats += 1
	if songPositionInBeats < beatsBeforeStart:
		$StartTimer.start()
	elif songPositionInBeats == beatsBeforeStart:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() - AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
		
	_report_beat()
