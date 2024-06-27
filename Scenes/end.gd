extends Node2D

var blue = Color(0,0,1,1)

func _ready():
	if Global.turn == 1:
			$CanvasLayer/ColorRect/player.set_text("P1")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", blue)
			print("hello")
	elif Global.turn == 2:
			$CanvasLayer/ColorRect/player.set_text("P1")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", blue)
			print("hi")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
