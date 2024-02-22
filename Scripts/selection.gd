extends Node2D

func _ready():
	$ColorRect/select_2p.hide()
	$ColorRect/Invalid.hide()

func _on_2p_pressed():
	$ColorRect/select_2p.show()
	add_items($ColorRect/select_2p/Label/menu_2p_1)
	add_items($ColorRect/select_2p/Label2/menu_2p_2)

func _on_3p_pressed():
	print("hello")

func _on_4p_pressed():
	print("hillo")

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
	var menu_1 = $ColorRect/select_2p/Label/menu_2p_1
	var menu_2 = $ColorRect/select_2p/Label2/menu_2p_2
	if menu_1.get_selected_id() == -1 or menu_2.get_selected_id() == -1:
		print("Please select an item in both menus.")
	else:
		var selected_item_1 = menu_1.get_selected_id()
		var selected_item_2 = menu_2.get_selected_id()
		if selected_item_1 != selected_item_2:
			get_tree().change_scene_to_file("res://Scenes/game.tscn")
		else:
			$ColorRect/Invalid.show()
