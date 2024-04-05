extends CanvasLayer

func _ready():
	SubMenu("hide")

func _on_balance_mouse_entered():
	SubMenu("show")
	
func SubMenu(vis):
	if vis == "show":
		$SubMenu.show()
		await timer()
		$SubMenu.hide()
	elif vis == "hide":
		$SubMenu.hide()

func timer():
	await get_tree().create_timer(5).timeout
