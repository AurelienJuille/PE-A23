extends Control


func _ready():
	$ColorRect2/MarginContainer/VBoxContainer/Button.grab_focus()

func _on_button_pressed():
	#$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	#$AudioStreamPlayer2D.play()
	await click_sound()
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")


func on_button_mouse_entered():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click1.ogg")
	$AudioStreamPlayer2D.play()



#func _on_button_mouse_exited():
	#$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click2.ogg")
	#$AudioStreamPlayer2D.play()



func click_sound():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	$AudioStreamPlayer2D.play()
