extends CanvasLayer

func _ready():
	SubMenu("hide")
	
func SubMenu(vis):
	if vis == "show":
		$SubMenu.show()
		await timer()
		$SubMenu.hide()
	elif vis == "hide":
		$SubMenu.hide()

func timer():
	await get_tree().create_timer(5).timeout

func _on_color_rect_mouse_entered():
	SubMenu("show")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("build")
