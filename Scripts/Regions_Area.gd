extends Area2D

var region_name = ""
var Owner = ""

func _ready():
	await timer()
	if region_name == "Steward Island":
		for node in get_children():
			if node.is_class("Polygon2D"):
				node.color = Color(0,0,255,1)

func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		node.color = Color(1,1,1,0.5)

func _on_mouse_entered():
	print(region_name)
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(1,1,1,1)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("Clicked: " + str(region_name))

func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = Color(1,1,1,0.5)
			
func timer():
	await get_tree().create_timer(1.0).timeout
