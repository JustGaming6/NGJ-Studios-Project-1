extends CanvasLayer

func _physics_process(delta):
	if Global.turn == 1:
		$player.set_text("P1")
		$ColorRect/balance.set_text(str(Global.p1_bal))
		$ColorRect/moral.set_text(str(Global.p1_moral) + "%")
		$ColorRect/manpower.set_text(str(Global.p1_manpower))
		if Global.p1_income < 0:
			$ColorRect/balance/bal_change.set_frame(1)
		elif Global.p1_income == 0:
			$ColorRect/balance/bal_change.set_frame(2)
		elif Global.p1_income > 0:
			$ColorRect/balance/bal_change.set_frame(0)
	elif Global.turn == 2:
		$player.set_text("P2")
		$ColorRect/balance.set_text(str(Global.p2_bal))
		$ColorRect/moral.set_text(str(Global.p2_moral) + "%")
		$ColorRect/manpower.set_text(str(Global.p2_manpower))
		if Global.p2_income < 0:
			$ColorRect/balance/bal_change.set_frame(1)
		elif Global.p2_income == 0:
			$ColorRect/balance/bal_change.set_frame(2)
		elif Global.p2_income > 0:
			$ColorRect/balance/bal_change.set_frame(0)
	elif Global.turn == 3:
		$player.set_text("P3")
		$ColorRect/balance.set_text(str(Global.p3_bal))
		$ColorRect/moral.set_text(str(Global.p3_moral) + "%")
		$ColorRect/manpower.set_text(str(Global.p3_manpower))
		if Global.p3_income < 0:
			$ColorRect/balance/bal_change.set_frame(1)
		elif Global.p3_income == 0:
			$ColorRect/balance/bal_change.set_frame(2)
		elif Global.p3_income > 0:
			$ColorRect/balance/bal_change.set_frame(0)
	elif Global.turn == 4:
		$player.set_text("P4")
		$ColorRect/balance.set_text(str(Global.p4_bal))
		$ColorRect/moral.set_text(str(Global.p4_moral) + "%")
		$ColorRect/manpower.set_text(str(Global.p4_manpower))
		if Global.p3_income < 0:
			$ColorRect/balance/bal_change.set_frame(1)
		elif Global.p3_income == 0:
			$ColorRect/balance/bal_change.set_frame(2)
		elif Global.p3_income > 0:
			$ColorRect/balance/bal_change.set_frame(0)

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

func _on_button_pressed():
	Global.turn += 1
	if Global.turn > Global.players:
		Global.turn = 1
