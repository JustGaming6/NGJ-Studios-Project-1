extends CanvasLayer

var factory_level = 1
var factory_cost = 1000
var factory_cost_valid = false
var factory_sell = 0
var factory_sell_valid = false

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
	match Global.turn:
		1:
			if Global.p1_bal >= factory_cost:
				if factory_level <= 5:
					factory_cost_valid = true
					$region_info/region_factory/upgrade.set_text("Upgrade: $" + str(factory_cost))
				else:
					$region_info/region_factory/upgrade.set_text("MAX")
			else:
				factory_cost_valid = false
			if factory_level != 1:
				factory_sell_valid = true
				$region_info/region_factory/sell.set_text("Sell: $" + str(factory_sell) )
			else:
				factory_sell_valid = false
				$region_info/region_factory/sell.set_text("TOO LOW")
		2:
			pass
		3:
			pass
		4:
			pass
		
	match factory_level:
		1:
			factory_cost = 1000
		2:
			pass
		3:
			pass
		4:
			pass

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

func _on_sell_pressed():
	if factory_sell_valid == true:
		var region_node = get_node("../Regions").get_node(Global.region_info_clicked)
		factory_level -= 1
		region_node.Income = region_node.Income / 1.2
		$region_info/region_income.set_text("Income: $" + str(region_node.Income))
