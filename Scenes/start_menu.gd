extends Control
var level = ["res://Levels/Level 1.tscn","res://Levels/Level 2.tscn"]
var index = 0
var levelNames = ["Level 1: City Landscapes", "Level 2: Sloppy Sewers"]
func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()

func _on_play_pressed():
	await click_sound()
	get_tree().change_scene_to_file(level[index])

func _on_quit_pressed():
	await click_sound()
	get_tree().quit()

func _on_tutorial_pressed():
	await click_sound()
	get_tree().change_scene_to_file("res://Scenes/Graphic_room.tscn")

func _on_prev_level_pressed():
	click_sound()
	index = (index - 1) % levelNames.size()
	update_label()

func _on_next_level_pressed():
	click_sound()
	index = (index + 1) % levelNames.size()
	update_label()

func update_label():
	$MarginContainer/VBoxContainer/HBoxContainer/LevelLabel.text = levelNames[index]

#func on_button_mouse_pressed():
	#$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	#$AudioStreamPlayer2D.play()
	#await $AudioStreamPlayer2D.finished
#
#func on_button_mouse_entered():
	#$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click1.ogg")
	#$AudioStreamPlayer2D.play()
	#await $AudioStreamPlayer2D.finished
#
#func _on_button_mouse_exited():
	#$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click2.ogg")
	#$AudioStreamPlayer2D.play()
	#await $AudioStreamPlayer2D.finished
	
	
func click_sound():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	$AudioStreamPlayer2D.play()
