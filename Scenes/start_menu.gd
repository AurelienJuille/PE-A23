extends Control
var level = ["res://Levels/Level 1.tscn","res://Levels/Level 2.tscn"]
var index = 0
var levelNames = ["Level 1: City Landscapes", "Level 2: Sloppy Sewers"]
func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()


func _on_play_pressed():
	get_tree().change_scene_to_file(level[index])


func _on_quit_pressed():
	get_tree().quit()


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/Graphic_room.tscn")


func _on_prev_level_pressed():
	index = (index - 1) % levelNames.size()
	update_label()
	print(index)
	pass # Replace with function body.


func _on_next_level_pressed():
	index = (index + 1) % levelNames.size()
	update_label()
	print(index)
	pass # Replace with function body.
	
func update_label():
	$MarginContainer/VBoxContainer/HBoxContainer/LevelLabel.text = levelNames[index]
