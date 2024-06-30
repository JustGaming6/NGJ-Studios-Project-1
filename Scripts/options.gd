extends Node2D





func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")



func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
