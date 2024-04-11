extends Control
var camera_speed = 10

func _physics_process(delta):
	camera_move()

func camera_move():
	if Input.is_action_pressed("right"):
		$Control/Camera2D.offset.x += camera_speed
	if Input.is_action_pressed("left"):
		$Control/Camera2D.offset.x -= camera_speed
	if Input.is_action_pressed("up"):
		$Control/Camera2D.offset.y-= camera_speed
	if Input.is_action_pressed("down"):
		$Control/Camera2D.offset.y += camera_speed
	
	if $Control/Camera2D.offset.x > 600:
		$Control/Camera2D.offset.x = 600
	if $Control/Camera2D.offset.x < -600:
		$Control/Camera2D.offset.x = -600
	if $Control/Camera2D.offset.y > 800:
		$Control/Camera2D.offset.y = 800
	if $Control/Camera2D.offset.y < -800:
		$Control/Camera2D.offset.y = -800

