extends Node3D

var last_executed_beat : int
@export var frequency : int
@export var start_beat : int
@export var end_beat : int
@export var animation : AnimationPlayer
var play = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	print(GLOBAL.MUSIC_CONTROL.songPositionInBeats)
	if GLOBAL.MUSIC_CONTROL.songPositionInBeats > start_beat and GLOBAL.MUSIC_CONTROL.songPositionInBeats < end_beat:
		play = true
	else:
		play = false
	if play and GLOBAL.MUSIC_CONTROL.songPositionInBeats % frequency == 0 and GLOBAL.MUSIC_CONTROL.songPositionInBeats != last_executed_beat:
		last_executed_beat = GLOBAL.MUSIC_CONTROL.songPositionInBeats
		print(GLOBAL.MUSIC_CONTROL.songPositionInBeats)
		print('GLOBAL.MUSIC_CONTROL.songPositionInBeats')
		animation.play('level 2')
