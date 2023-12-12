extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click3.ogg")
	$AudioStreamPlayer2D.play()
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	pass # Replace with function body.

func on_button_mouse_entered():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click1.ogg")
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.


func _on_button_mouse_exited():
	$AudioStreamPlayer2D.stream = load("res://Audio/SFX/click2.ogg")
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.
