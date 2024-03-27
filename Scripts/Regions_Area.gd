extends Area2D

var region_name = ""
var Owner = ""
var intial_font = ""
var p1_col = Color(0,0,255,1)
var p2_col = Color(255,0,0,1)
var p3_col = Color(130,94,92,1)
var p4_col = Color(255,240,0,1)
var bot_col = Color(46,204,113,1)

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
	elif Global.region_owner == "bot":
		node.color = bot_col

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
