extends Node2D

@onready var mapImage = $Sprite2D

var camera_speed = 10
var zoom_speed = 0.25
var loading_screen = false
var once = false
var tutorial_stage = 1

var region_info
var region
var troops_label
var purchase_valid

var left
var middle
var right
var left_label
var middle_label
var right_label

func _ready():
	Global.tutorial = true
	load_regions()   
	await change_owner("Graysonville", "bot1")
	await change_owner("Greyland", "p1")
	await change_owner("Republic of Grayland", "bot2")
	$tutorial/ColorRect/text.set_text("Hello and welcome to New Zealand Conquest, 
	Click the 'NEXT' button bellow to 
	start the tutorial")
	$tutorial/ColorRect/title.set_text("Welcome")       
	$tutorial/ColorRect.show()
	$tutorial/maximise.hide()
	middle = get_node("Regions").get_node("Greyland")
	left = get_node("Regions").get_node("Republic of Grayland")
	right = get_node("Regions").get_node("Graysonville")
	middle_label = get_node("Regions").get_node("Greyland").get_node("label")
	left_label = get_node("Regions").get_node("Republic of Grayland").get_node("label")
	right_label = get_node("Regions").get_node("Graysonville").get_node("label")                                                                                                                                                                                                                                                            
	
func _physics_process(delta):
	if loading_screen == false: # If not on the loading screen run the camera movement functions
		zoom()
		camera_move()
	if Global.region_clicked == true: #Add troop to clicked region
		Global.region_clicked = false
		var region = get_node("Regions").get_node(Global.troops_region_name)
		if str(region.Owner) == "p1":
			purchase(200, "p1")
			if purchase_valid == true:
				region.Troops += 1
				var troops_label = get_node("Regions").get_node(Global.troops_region_name).get_node("label")
				troops_label.set_text(str(region.Troops))
	match tutorial_stage:
		12:
			if Global.attack_region == "Greyland" and Global.defense_region == "Republic of Grayland":
				left.Troops = 5
				change_owner("Republic of Grayland", "p1")
				middle.Troops = 1
				left_label.set_text(str(left.Troops))
				middle_label.set_text(str(middle.Troops))
		14: 
			if Global.attack_region == "Republic of Grayland" and Global.defense_region == "Greyland":
				left.Troops = 1
				middle.Troops = 4
				left_label.set_text(str(left.Troops))
				middle_label.set_text(str(middle.Troops))
		17:
			if Global.attack_region == "Greyland" and Global.defense_region == "Graysonville":
				middle.Troops = 1
				right.Troops = 1
				change_owner("Graysonville", "p1")
				right_label.set_text(str(right.Troops))
				middle_label.set_text(str(middle.Troops))
				
func _process(delta):
	match tutorial_stage:
		2:
			$tutorial/ColorRect/title.set_text("Minimise/ Maximise")
			$tutorial/ColorRect/text.set_text("Throughout the tutorial if the 
			tutorial box is getting annoying you 
			can press the minimise button (-) to 
			remove the box. You can press the maximise 
			button (+) to show the tutorial box again.")
		3:
			$tutorial/ColorRect/title.set_text("Movement")
			$tutorial/ColorRect/text.set_text("To move you can either use the 
			W,A,S,D keys or point and drag with 
			your mouse. Click 'NEXT' when you 
			want to move on")
		4:
			$tutorial/ColorRect/title.set_text("ZOOM")
			$tutorial/ColorRect/text.set_text("To zoom in and out use your scroll 
			wheel on your mouse. Click 'NEXT' 
			when you wish to continue")
		5:
			$tutorial/ColorRect/title.set_text("UI")
			$tutorial/ColorRect/text.set_text("The Header at the top of your 
			screen shows you (from left to right) 
			your 'BALANCE', 'Moral', and 'Manpower'.
			The only one currently important
			one is your balance.")
		6:
			$tutorial/ColorRect/title.set_text("UI")
			$tutorial/ColorRect/text.set_text("To the right of the Header 
			there is the players turn follow 
			my the 'End Turn'. In games you 
			will click this button when you 
			wish to finish your turn")
		7:
			$tutorial/ColorRect/title.set_text("Deployment")
			$tutorial/ColorRect/text.set_text("At the start of each turn 
			you enter deployment phase. 
			During this phase you can left
			 click territories that you 
			own to place a troop there. 
			Each troop costs $200.")
		8:
			$tutorial/ColorRect/title.set_text("Deployment")
			$tutorial/ColorRect/text.set_text("Now try deploying. 
			You are the blue player in 
			the middle territory. Add
			troops until you no longer 
			have enough money.")
			Global.tutorial = false
			Global.deployment_phase = true
			$TroopSelection.show()
			if once == false:
				Global.p1_bal += 1000
				once = true
				$CanvasLayer/ColorRect/balance.set_text(str(Global.p1_bal))
		9:
			$tutorial/ColorRect/title.set_text("Exit Deployment")
			$tutorial/ColorRect/text.set_text("Now you exit deployment by 
			clicking 'Exit Deployment' 
			button above this box.")
			Global.tutorial = true
		10:
			$tutorial/ColorRect/title.set_text("Attack Phase")
			$tutorial/ColorRect/text.set_text("Now you are in the attack 
			phase. In this phase you move 
			troops around to take other 
			Territories")
		11:
			$tutorial/ColorRect/title.set_text("Attacking")
			$tutorial/ColorRect/text.set_text("To attack left on click on your 
			own territory that you want to 
			attack from then right click the 
			territory you want to attack. 
			The Territories must be next
			 to each other.")
		12:
			$tutorial/ColorRect/title.set_text("Attack")
			$tutorial/ColorRect/text.set_text("Now you try it. Left click on your 
			Territory in the middle then 
			Right click the Territory to 
			the left of it.")
			Global.tutorial = false
		13:
			$tutorial/ColorRect/title.set_text("Troop Movement")
			$tutorial/ColorRect/text.set_text("You can move troops through your 
			own territory by attacking it. 
			This process costs 1 Troop per 
			territory though")
			Global.tutorial = true
		14:
			$tutorial/ColorRect/title.set_text("Troop Movement")
			$tutorial/ColorRect/text.set_text("Now you try it. Left the click 
			the left Territory then right 
			click the middle region to move
			the troops from the left 
			territory to the right.")
			Global.tutorial = false
		15:
			$tutorial/ColorRect/title.set_text("Winning")
			$tutorial/ColorRect/text.set_text("To win the game you must 
			own all Territories")
		16:
			$tutorial/ColorRect/title.set_text("Income")
			$tutorial/ColorRect/text.set_text("Every Territory has different Income, Capture 
			Territories gives you there 
			Income. Therefore the more 
			Territories you own the higher 
			Income you have")
		17:
			$tutorial/ColorRect/title.set_text("Finish the Game")
			$tutorial/ColorRect/text.set_text("Now take the last Territory 
			and click the end turn button 
			to win the game.")
			Global.tutorial = true

func purchase(cost, turn): #Checking if a troop purchase is valid (e.g. has enough money)
	purchase_valid = false
	if Global.p1_bal >= cost:
		purchase_valid = true
		Global.p1_bal -= cost
		$CanvasLayer/ColorRect/balance.set_text(str(Global.p1_bal))

func zoom(): #Function for zoom
	if $Regions/Camera2D.zoom.x > 5:
		zoom_speed = 1
	elif $Regions/Camera2D.zoom.x < 5:
		zoom_speed = 0.25
	if Input.is_action_just_released("wheel up"):
		if $Regions/Camera2D.zoom.x <= 10:
			$Regions/Camera2D.zoom.x += zoom_speed
			$Regions/Camera2D.zoom.y += zoom_speed
	if Input.is_action_just_released("wheel down"):
		if $Regions/Camera2D.zoom.x >0.5:
			$Regions/Camera2D.zoom.x -= zoom_speed
			$Regions/Camera2D.zoom.y -= zoom_speed

func camera_move(): #Function for camera movement (Both wasd and mouse)
	if $Regions/Camera2D.zoom.x > 1:
		camera_speed = 5
	elif $Regions/Camera2D.zoom.x <= 1:
		camera_speed = 10
	
	if Input.is_action_pressed("right"):
		$Regions/Camera2D.offset.x += camera_speed
	if Input.is_action_pressed("left"):
		$Regions/Camera2D.offset.x -= camera_speed
	if Input.is_action_pressed("up"):
		$Regions/Camera2D.offset.y-= camera_speed
	if Input.is_action_pressed("down"):
		$Regions/Camera2D.offset.y += camera_speed
	
	if $Regions/Camera2D.offset.x > 600:
		$Regions/Camera2D.offset.x = 600
	if $Regions/Camera2D.offset.x < -600:
		$Regions/Camera2D.offset.x = -600
	if $Regions/Camera2D.offset.y > 800:  
		$Regions/Camera2D.offset.y = 800
	if $Regions/Camera2D.offset.y < -800:
		$Regions/Camera2D.offset.y = -800
		
func load_regions(): #Function to load the regions at the start of the game
	var image = mapImage.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var regions_dict = import_file("res://tutorial.txt")
	for region_color in regions_dict:
		region = load("res://Scenes/tutorial_area.tscn").instantiate()
		region_info = regions_dict[region_color]
		region.region_name =  region_info[0]
		region.set_name(region_info[0])
		region.Owner =  "region_owner"
		region.Income = region_info[1]
		region.Manpower = region_info[2]
		region.Troops = int(region_info[3])
		get_node("Regions").add_child(region)
		
		var polygons = get_polygons(image, region_color, pixel_color_dict)
		
		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision)
			region.add_child(region_polygon)
			
			var centre = Vector2.ZERO
			for vertex in polygon:
				centre += vertex
			centre /= polygon.size()
			
			troops_label = Label.new()
			troops_label.set_text(str(region.Troops))
			troops_label.set_name("label")
			
			troops_label.position = centre
			troops_label.position.y -= 15
			troops_label.position.x -= 5
			region.add_child(troops_label)
			
func get_pixel_color_dict(image): #Apart of Load regions
	var pixel_color_dict = {}
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel_color = "#" + str(image.get_pixel(int(x), int (y)).to_html(false))
			if pixel_color not in pixel_color_dict:
				pixel_color_dict[pixel_color] = []
			pixel_color_dict[pixel_color].append(Vector2(x,y))
	return pixel_color_dict

func get_polygons(image, region_color, pixel_color_dict): #Apart of load regions
	var targetImage = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)
	for value in pixel_color_dict[region_color]:
			targetImage.set_pixel(value.x, value.y, "#ffffff")
			
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()), 0.1)
	
	return polygons
	
func import_file(filepath): #Acces file (Used for the load regions function)
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		print("Faild to Open file: ", filepath)
		return null
		
func change_owner(region_name: String, new_owner : String): #Change the owner of the territory and the regions resources
	var region = get_node("Regions").get_node(region_name)
	if region != null:
	
		region.Owner = new_owner
		Global.region_owner = region.Owner
		Global.region_name = region_name
		print(region_name + ": " + region.Owner)

	else:
		print("Region not found: " + region_name)
	await timer()
	

func timer(): #Timer for setting regions
	await get_tree().create_timer(0.2).timeout


func _on_next_pressed():
	match tutorial_stage:
		1,2,3,4,5,6,7,10,11,13,15,16:
			tutorial_stage += 1
		8:
			if middle.Troops >= 6:
				tutorial_stage += 1
		9:
			if Global.deployment_phase == false:
				tutorial_stage += 1
		12:
			if left.Owner == "p1":
				tutorial_stage += 1
		14:
			if middle.Troops == 4:
				tutorial_stage += 1

func _on_minimise_pressed():
	$tutorial/ColorRect.hide()
	$tutorial/maximise.show()

func _on_maximise_pressed():
	$tutorial/ColorRect.show()
	$tutorial/maximise.hide()

func _on_button_pressed():
	Global.deployment_phase = false
	$TroopSelection.hide()

func _on_endturn_button_pressed():
	if tutorial_stage == 17:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
