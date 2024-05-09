extends Node2D

func _ready():
	$ColorRect/select.hide()
	$ColorRect/select.hide()
	$ColorRect/Invalid.hide()
	$ColorRect/select/Label.hide()
	$ColorRect/select/Label2.hide()
	$ColorRect/select/Label3.hide()
	$ColorRect/select/Label4.hide()

func _on_2p_pressed():
	Global.players = 2
	$ColorRect/select.show()
	add_items($ColorRect/select/Label/menu_1)
	add_items($ColorRect/select/Label2/menu_2)
	$ColorRect/select/Label.show()
	$ColorRect/select/Label2.show()
	
	$ColorRect/select/Label3.hide()
	$ColorRect/select/Label4.hide()

func _on_3p_pressed():
	Global.players = 3
	$ColorRect/select.show()
	add_items($ColorRect/select/Label/menu_1)
	add_items($ColorRect/select/Label2/menu_2)
	add_items($ColorRect/select/Label3/menu_3)
	$ColorRect/select/Label.show()
	$ColorRect/select/Label2.show()
	$ColorRect/select/Label3.show()
	
	$ColorRect/select/Label4.hide()

func _on_4p_pressed():
	Global.players = 4
	$ColorRect/select.show()
	add_items($ColorRect/select/Label/menu_1)
	add_items($ColorRect/select/Label2/menu_2)
	add_items($ColorRect/select/Label3/menu_3)
	add_items($ColorRect/select/Label4/menu_4)
	$ColorRect/select/Label.show()
	$ColorRect/select/Label2.show()
	$ColorRect/select/Label3.show()
	$ColorRect/select/Label4.show()

func add_items(name):
	name.add_item("Northland")
	name.add_item("Auckland")
	name.add_item("Bay of plenty")
	name.add_item("Waikato")
	name.add_item("Taranaki")
	name.add_item("Hawkes Bay")
	name.add_item("Wellington")
	name.add_item("Marlbrough/Tasman")
	name.add_item("West Coast")
	name.add_item("Canterbury")
	name.add_item("Otago")
	name.add_item("Southland")

func _on_done_2p_pressed():
	var menu_1 = $ColorRect/select/Label/menu_1
	var menu_2 = $ColorRect/select/Label2/menu_2
	var menu_3 = $ColorRect/select/Label3/menu_3
	var menu_4 = $ColorRect/select/Label4/menu_4
	if Global.players == 2:
		if menu_1.get_selected_id() == -1 or menu_2.get_selected_id() == -1:
			print("Please select an item in both menus.")
		else:
			$ColorRect/Invalid.show()
			var selected_item_1 = menu_1.get_selected_id()
			var selected_item_2 = menu_2.get_selected_id()
			if selected_item_1 != selected_item_2:
				get_tree().change_scene_to_file("res://Scenes/game.tscn")
				Global.p1_selection = selected_item_1
				Global.p2_selection = selected_item_2
			else:
				$ColorRect/Invalid.show()
	elif Global.players == 3:
		if menu_1.get_selected_id() == -1 or menu_2.get_selected_id() == -1 or menu_3.get_selected_id() == -1:
			print("Please select an item in all menus.")
		else:
			$ColorRect/Invalid.show()
			var selected_item_1 = menu_1.get_selected_id()
			var selected_item_2 = menu_2.get_selected_id()
			var selected_item_3 = menu_3.get_selected_id()
			if selected_item_1 != selected_item_2 and selected_item_1 != selected_item_3:
				get_tree().change_scene_to_file("res://Scenes/game.tscn")
				Global.p1_selection = selected_item_1
				Global.p2_selection = selected_item_2
				Global.p3_selection = selected_item_3
			else:
				$ColorRect/Invalid.show()
	elif Global.players == 4:
		if menu_1.get_selected_id() == -1 or menu_2.get_selected_id() == -1 or menu_3.get_selected_id() == -1 or menu_4.get_selected_id() == -1:
			print("Please select an item in all menus.")
		else:
			$ColorRect/Invalid.show()
			var selected_item_1 = menu_1.get_selected_id()
			var selected_item_2 = menu_2.get_selected_id()
			var selected_item_3 = menu_3.get_selected_id()
			var selected_item_4 = menu_4.get_selected_id()
			if selected_item_1 != selected_item_2 and selected_item_1 != selected_item_3 and selected_item_1 != selected_item_4:
				get_tree().change_scene_to_file("res://Scenes/game.tscn")
				Global.p1_selection = selected_item_1
				Global.p2_selection = selected_item_2
				Global.p3_selection = selected_item_3
				Global.p4_selection = selected_item_4
			else:
				$ColorRect/Invalid.show()


func _on_menu_pressed():
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
