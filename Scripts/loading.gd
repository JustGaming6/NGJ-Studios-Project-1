extends ColorRect

func _ready():
	$Sprite2D/AnimationPlayer.play("loading")

func _physics_process(delta):
	if $Sprite2D.frame == 0:
		$Sprite2D.rotation = 0
	elif $Sprite2D.frame == 27:
		$Sprite2D.rotation = -3.14 / 4
	elif $Sprite2D.frame == 28:
		$Sprite2D.rotation = -3.14/ 2
	elif $Sprite2D.frame == 29:
		$Sprite2D.rotation= -3.14 * .75
	elif $Sprite2D.frame == 30:
		$Sprite2D.rotation == PI
