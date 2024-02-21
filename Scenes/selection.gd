extends Node2D

func _ready():
	$ColorRect/select_2p.hide()

func _on_2p_pressed():
	$ColorRect/select_2p.show()
	add_items($ColorRect/select_2p/Label/menu_2p_1)
	add_items($ColorRect/select_2p/Label2/menu_2p_2)

func _on_3p_pressed():
	print("hello")

func _on_4p_pressed():
	print("hillo")

func add_items(name):
	name.add_item("Wellington")
	name.add_item("Waikato")

func _on_done_2p_pressed():
	pass
