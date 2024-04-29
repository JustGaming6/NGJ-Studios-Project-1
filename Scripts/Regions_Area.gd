extends Area2D

var region_name = ""
var Owner = ""
var intial_font = ""
var p1_col = Color(0,0,1,1) #Blue
var p2_col = Color(1,0,0,1) #Red
var p3_col = Color(0,1,0,1) #Green
var p4_col = Color(1,1,0,1) #Yellow
var bot1_col = Color(1, 0.980392, 0.941176, 1)
var bot2_col = Color(0.5,0.25,0,1)
var bot3_col = Color(0,1,0,0.5)
var bot4_col = Color (1,0,0,0.5)
var bot5_col = Color(0,1,1,1)
var bot6_col = Color(0,1,1,0.5)
var bot7_col = Color(1,1,0,0.5)
var bot8_col = Color(1, 0.0784314, 0.576471, 1)
var bot9_col = Color(0.541176, 0.168627, 0.886275, 1)
var bot10_col = Color(0, 0, 0.545098, 1)
var bot11_col = Color(0.545098, 0, 0.545098, 1)
var bot12_Col = Color(1, 0.54902, 0, 1)

func _ready():
	await timer()

func change_color(node):
	if Global.region_owner == "p1":
		node.color = p1_col
	elif Global.region_owner == "p2":
		node.color = p2_col
	elif Global.region_owner == "p3":
		node.color = p3_col
	elif Global.region_owner == "p4":
		node.color = p4_col
	elif Global.region_owner == "bot1":
		node.color = bot1_col
	elif Global.region_owner == "bot2":
		node.color = bot2_col
	elif Global.region_owner == "bot3":
		node.color = bot3_col
	elif Global.region_owner == "bot4":
		node.color = bot4_col
	elif Global.region_owner == "bot5":
		node.color = bot5_col
	elif Global.region_owner == "bot6":
		node.color = bot6_col
	elif Global.region_owner == "bot7":
		node.color = bot7_col
	elif Global.region_owner == "bot8":
		node.color = bot8_col
	elif Global.region_owner == "bot9":
		node.color = bot9_col
	elif Global.region_owner == "bot10":
		node.color = bot10_col
	elif Global.region_owner == "bot11":
		node.color = bot11_col
	elif Global.region_owner == "bot12":
		node.color = bot12_Col

func _physics_process(delta):
		if region_name == Global.region_name:
			for node in get_children():
				if node.is_class("Polygon2D"):
					change_color(node)

func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		node.color = Color(1,1,1,0.5)

func _on_mouse_entered():
	print(region_name)
	for node in get_children():
		if node.is_class("Polygon2D"):
			intial_font = node.color
			node.color = Color(1,1,1,1)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("Clicked: " + str(region_name))

func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = intial_font
			
func timer():
	await get_tree().create_timer(1.0).timeout
