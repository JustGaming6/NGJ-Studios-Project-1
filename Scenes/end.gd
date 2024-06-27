extends Node2D

var blue = Color(0,0,1,1)
var red = Color(1,0,0,1)
var green = Color(0,1,0,1)
var yellow = Color(1,1,0,1)

func _ready():
	match Global.winner:
		1:
			$CanvasLayer/ColorRect/player.set_text("P1")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", blue)
		2:
			$CanvasLayer/ColorRect/player.set_text("P2")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", red)
		3:
			$CanvasLayer/ColorRect/player.set_text("P3")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", green)
		4:
			$CanvasLayer/ColorRect/player.set_text("P4")
			$CanvasLayer/ColorRect/player.set("theme_override_colors/font_color", yellow)
