extends Node3D


func init():
	for child in get_children():
		child.init()
