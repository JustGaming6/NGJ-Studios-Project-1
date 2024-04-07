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
