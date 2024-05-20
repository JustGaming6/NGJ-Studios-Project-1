extends Area2D

var region_name = ""
var Owner = ""
var Income = 0
var Manpower = 0
var Troops = 0
var intial_font = ""
var p1_col = Color(0,0,1,1) #Blue
var p2_col = Color(1,0,0,1) #Red
var p3_col = Color(0,1,0,1) #Green
var p4_col = Color(1,1,0,1) #Yellow
var bot1_col = Color(1, 0.980392, 0.941176, 0.5)
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

signal troops_added(region)

func _ready():
	await timer()

func change_color(node):
	match Global.region_owner:
		"p1":
			node.color = p1_col
		"p2":
			node.color = p2_col
		"p3":
			node.color = p3_col
		"p4":
			node.color = p4_col
		"bot1":
			node.color = bot1_col
		"bot2":
			node.color = bot2_col
		"bot3":
			node.color = bot3_col
		"bot4":
			node.color = bot4_col
		"bot5":
			node.color = bot5_col
		"bot6":
			node.color = bot6_col
		"bot7":
			node.color = bot7_col
		"bot8":
			node.color = bot8_col
		"bot9":
			node.color = bot9_col
		"bot10":
			node.color = bot10_col
		"bot11":
			node.color = bot11_col
		"bot12":
			node.color = bot12_Col

func _physics_process(delta):
		if region_name == Global.region_name:
			for node in get_children():
				if node.is_class("Polygon2D"):
					change_color(node)

func _on_child_entered_tree(node):
	if node.is_class("Polygon2D"):
		node.color = Color(0, 0, 0, 0.5)

func _on_mouse_entered():
	for node in get_children():
		if node.is_class("Polygon2D"):
			intial_font = node.color
			node.color = Color(1,1,1,1)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if Global.deployment_phase == true:
			Global.region_clicked = true
			Global.troops_region_name = region_name
		else:
			print("Attacking from: " + str(region_name))
			Global.attack_region = region_name
		if Global.attack_region == "blank":
			print("error")
		else:
			print("To " + str(region_name))
			Global.defense_region = region_name

func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = intial_font
			
func timer():
	await get_tree().create_timer(1.0).timeout
