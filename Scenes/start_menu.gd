extends Control

func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Levels/Level 1.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/Graphic_room.tscn")
