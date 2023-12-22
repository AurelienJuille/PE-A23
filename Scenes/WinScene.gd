extends Control


func _ready():
	$ColorRect2/MarginContainer/VBoxContainer/MainMenu.grab_focus()


func on_button_mouse_entered():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click1.ogg")
	$AudioStreamPlayer2D.play()

#func _on_button_mouse_exited():
#	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click2.ogg")
#	$AudioStreamPlayer2D.play()
#	await $AudioStreamPlayer3D.finished

func click_sound():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	$AudioStreamPlayer2D.play()


func _on_try_again_pressed():
	get_tree().change_scene_to_file(GLOBAL.CURRENTLEVEL)
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
