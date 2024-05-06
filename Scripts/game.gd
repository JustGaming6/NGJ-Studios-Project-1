extends Node2D

@onready var mapImage = $Sprite2D

var camera_speed = 10
var zoom_speed = 0.25
var loading_screen = false

func _ready():
	$BlankScreens/p1Screen.hide()
	$BlankScreens/Button.hide()
	loading_screen = true
	load_screen("loading")
	load_regions()
	await set_bot()
	await set_region(Global.p1_selection, "p1")
	await set_region(Global.p2_selection, "p2")
	if Global.players > 2:
		await set_region(Global.p3_selection, "p3")
		if Global.players > 3:
			await set_region(Global.p4_selection, "p4")
	loading_screen = false
	load_screen("game")
	load_screen("p1")
	print(Global.p1_income)                                                                                                                                                                                                                                                                                                                           
	
func _physics_process(delta):
	if loading_screen == false:
		zoom()
		camera_move()
	
func _process(delta):
	pass
	
func zoom():
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

func camera_move():
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
		
func load_regions():
	var image = mapImage.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var regions_dict = import_file("res://regions.txt")
	
	for region_color in regions_dict:
		var region = load("res://Scenes/Regions_Area.tscn").instantiate()
		var region_info = regions_dict[region_color]
		region.region_name =  region_info[0]
		region.set_name(region_info[0])
		region.Owner =  "region_owner"
		get_node("Regions").add_child(region)
		
		Global.region_income = region_info[1]
		Global.region_manpower = region_info[2] 
		
		var polygons = get_polygons(image, region_color, pixel_color_dict)
		
		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new()
			var region_polygon = Polygon2D.new()
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision)
			region.add_child(region_polygon)
			
func get_pixel_color_dict(image):
	var pixel_color_dict = {}
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel_color = "#" + str(image.get_pixel(int(x), int (y)).to_html(false))
			if pixel_color not in pixel_color_dict:
				pixel_color_dict[pixel_color] = []
			pixel_color_dict[pixel_color].append(Vector2(x,y))
	return pixel_color_dict

func get_polygons(image, region_color, pixel_color_dict):
	var targetImage = Image.create(image.get_size().x, image.get_size().y, false, Image.FORMAT_RGBA8)
	for value in pixel_color_dict[region_color]:
			targetImage.set_pixel(value.x, value.y, "#ffffff")
			
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(targetImage)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()), 0.1)
	
	return polygons
	
func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		print("Faild to Open file: ", filepath)
		return null
		
func change_owner(region_name: String, new_owner : String):
	var region = get_node("Regions").get_node(region_name)
	if region != null:
		region.Owner = new_owner
		Global.region_owner = region.Owner
		Global.region_name = region_name
		print(region_name + ": " + region.Owner)
		match new_owner:
			"p1":
				Global.p1_income += Global.region_income
			"p2":
				Global.p2_income += Global.region_income
			"p3":
				Global.p3_income += Global.region_income
			"p4":
				Global.p4_income += Global.region_income
	else:
		print("Region not found: " + region_name)
	await timer()
	
func turn(player):
	load_screen("game")
	load_screen(player)

func set_region(selection, player):
	match selection:
		0:
			await change_northland(player)
		1:
			await change_auckland(player)
		2:
			await change_bayofplenty(player)
		3:
			await change_waikato(player)
		4:
			await change_taranaki(player)
		5:
			await change_hawkesbay(player)
		6:
			await change_wellington(player)
		7:
			await change_marlbroughtasman(player)
		8:
			await change_westcoast(player)
		9:
			await change_canterbury(player)
		10:
			await change_fiordland(player)
		11:
			await change_southland(player)
	
func set_bot():
	await change_northland("bot1")
	await change_auckland("bot2")
	await change_waikato("bot3")
	await change_bayofplenty("bot4")
	await change_taranaki("bot5")
	await change_hawkesbay("bot6")
	await change_wellington("bot7")
	await change_marlbroughtasman("bot8")
	await change_westcoast("bot9")
	await change_canterbury("bot10")
	await change_fiordland("bot11")
	await change_southland("bot12")

func change_northland(player):
	await change_owner("Far North", player)
	await change_owner("Whangarei", player)
	await change_owner("Kaipara", player)
func change_auckland(player):
	await change_owner("North Auckland", player)
	await change_owner("Central Auckland", player)
	await change_owner("South Auckland", player)
	await change_owner("West Auckland", player)
	await change_owner("Coromandel", player)
func change_bayofplenty(player):
	await change_owner("Gisborne", player)
	await change_owner("Opotiki", player)
	await change_owner("Whakatane", player)
	await change_owner("Rotorua", player)
	await change_owner("Tauranga", player)
func change_waikato(player):
	await change_owner("North Waikato", player)
	await change_owner("Hauraki", player)
	await change_owner("Hamilton",player)
	await change_owner("Waitomo", player)
	await change_owner("Taupo", player)
	await change_owner("Desert Road", player)
func change_taranaki(player):
	await change_owner("South Taranaki", player)
	await change_owner("Whanganui", player)
	await change_owner("New Plymouth", player)
	await change_owner("Stratford", player)
	await change_owner("Ruapehu", player)
func change_hawkesbay(player):
	await change_owner("Central Hawke's Bay", player)
	await change_owner("Hastings", player)
	await change_owner("Napier", player)
	await change_owner("Wairoa", player)
func change_wellington(player):
	await change_owner("Wellington", player)
	await change_owner("South Wairarapa", player)
	await change_owner("Masterton", player)
	await change_owner("Tararua Region", player)
	await change_owner("Palmerston North", player)
	await change_owner("Kapiti Coast", player)
	await change_owner("North Manawatu", player)
func change_marlbroughtasman(player):
	await change_owner("Tasman", player)
	await change_owner("Marlbrough", player)
	await change_owner("Nelson", player)
	await change_owner("Kaikoura", player)
func change_canterbury(player):
	await change_owner("Hurunui", player)
	await change_owner("Christchurch", player)
	await change_owner("Waimakariri", player)
	await change_owner("Selwyn", player)
	await change_owner("Ashburton", player)
	await change_owner("Waitaki", player)
func change_westcoast(player):
	await change_owner("Southern West Coast", player)
	await change_owner("Hokitika", player)
	await change_owner("Greymouth", player)
func change_fiordland(player):
	await change_owner("Queenstown", player)
	await change_owner("Wanaka", player)
	await change_owner("Otago", player)
	await change_owner("Dunedin", player)
func change_southland(player):
	await change_owner("Stewart Island", player)
	await change_owner("Invercargill", player)
	await change_owner("Fiordland", player)

func timer():
	await get_tree().create_timer(0.2).timeout

func load_screen(screen):
	match screen:
		"loading":
			$BlankScreens/LoadingScreen.show()
		"p1":
			$BlankScreens/p1Screen.show()
			$BlankScreens/Button.show()
		"p2":
			$BlankScreens/p2Screen.show()
			$BlankScreens/Button.show()
		"p3":
			$BlankScreens/p3Screen.show()
			$BlankScreens/Button.show()
		"p4":
			$BlankScreens/p4Screen.show()
			$BlankScreens/Button.show()
		"game":
			$BlankScreens/LoadingScreen.hide()
			$BlankScreens/p1Screen.hide()
			$BlankScreens/p2Screen.hide()
			$BlankScreens/p3Screen.hide()
			$BlankScreens/p4Screen.hide()
			$BlankScreens/Button.hide()

func _on_button_pressed():
	load_screen("game")

func _on_turnbutton_pressed():
	Global.turn += 1
	if Global.turn > Global.players:
		Global.turn = 1
	match Global.turn:
		1: 
			await turn("p1")
		2:
			await turn("p2")
		3:
			await turn("p3")
		4:
			await turn("p4")
