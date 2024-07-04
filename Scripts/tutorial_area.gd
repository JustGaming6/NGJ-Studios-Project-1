extends Area2D

var region_name = ""
var Owner = ""
var Income = 0
var Manpower = 0
var Troops = 0
var intial_font = ""
var p1_col = Color(0,0,1,1) #Blue
var bot1_col = Color(1,0,0,1) #Red
var bot2_col = Color(0,1,0,1) #Green

func _ready():
	await timer()

func change_color(node):
	match Global.region_owner:
		"p1":
			node.color = p1_col
		"bot1":
			node.color = bot1_col
		"bot2":
			node.color = bot2_col

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
			var current_color = node.color
			var lighten_color = Color(current_color.r, current_color.g, current_color.b, 0.5)
			node.color = lighten_color

func _on_input_event(viewport, event, shape_idx):
	if Global.tutorial == false:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if Global.deployment_phase == true:
				Global.region_clicked = true
				Global.troops_region_name = region_name
			else:
				print("Attacking from: " + str(region_name))
				Global.attack_region = region_name
				if Global.attack_region == "blank":
					print("error")
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			if Global.deployment_phase == false:
				print("To: " + str(region_name))
				Global.defense_region = region_name

func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			node.color = intial_font
			
func timer():
	await get_tree().create_timer(1.0).timeout
