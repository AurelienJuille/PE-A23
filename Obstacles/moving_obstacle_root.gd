extends Node3D

@export var starting_sub_beat: int
@export var ending_sub_beat: int
@export var looping: bool

@export var end_pos: Vector3


func init():
	GLOBAL.MUSIC_CONTROL.currentSubBeatSignal.connect(_on_music_control_current_sub_beat_signal)
	$AnimationPlayer.speed_scale = GLOBAL.MUSIC_CONTROL.subMeasureDivision * GLOBAL.MUSIC_CONTROL.bpm / 60.0

func _on_music_control_current_sub_beat_signal():
	var beat = GLOBAL.MUSIC_CONTROL.currentSubBeat if looping else GLOBAL.MUSIC_CONTROL.lastReportedSubBeat
	var tween = get_tree().create_tween()
	
	if beat == starting_sub_beat:
		if $AnimationPlayer.has_animation("anim"):
			$AnimationPlayer.play("anim")
		else:
			tween.tween_property(get_child(-1), "position", end_pos, GLOBAL.MUSIC_CONTROL.secondsPerBeat / GLOBAL.MUSIC_CONTROL.subMeasureDivision)
			await tween.finished
			
	elif beat == ending_sub_beat:
		if $AnimationPlayer.has_animation("anim"):
			$AnimationPlayer.play_backwards("anim")
		else:
			tween.tween_property(get_child(-1), "position", Vector3.ZERO, GLOBAL.MUSIC_CONTROL.secondsPerBeat / GLOBAL.MUSIC_CONTROL.subMeasureDivision)
			await tween.finished

