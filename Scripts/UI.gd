extends CanvasLayer


func _ready():
	SubMenu("hide")
	$region_info.hide()

func _process(delta):
	if Global.region_info_clicked != "blank":
		var region_node = get_node("../Regions").get_node(Global.region_info_clicked)
		$region_info/region_name.set_text(Global.region_info_clicked)
		$region_info/region_income.set_text("Income: $" + str(region_node.Income))
		$region_info/region_manpower.set_text("Manpower: $" + str(region_node.Manpower))
		match region_node.Nuke:
			true:
				$region_info/radioactivity.set_text("Radioactivity: DEADLY")
			false:
				$region_info/radioactivity.set_text("Radioactivity: LOW")
				
		
		$region_info.show()

func _physics_process(delta):
	if Global.turn == 1:
		if Global.p1_territories > 0:
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
		if Global.p2_territories > 0:
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
		if Global.p3_territories > 0:
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
		if Global.p4_territories > 0:
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


func _on_nuke_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var valid = false
		match Global.turn:
			1:
				if Global.p1_bal >= 5000:
					valid = true
			2:
				if Global.p2_bal >= 5000:
					valid = true
			3:
				if Global.p3_bal >= 5000:
					valid = true
			4:
				if Global.p4_bal >= 5000:
					valid = true
		if valid == true:
			Global.nuke_deployment = true

func _on_info_back_pressed():
	Global.region_info_clicked = "blank"
	$region_info.hide()
	print("hi")
