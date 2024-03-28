extends Node2D

@onready var mapImage = $Sprite2D

var camera_speed = 10

func _ready():
	load_regions()
	await set_region(Global.p1_selection, "p1")
	await set_region(Global.p2_selection, "p2")
	if Global.players > 2:
		await set_region(Global.p3_selection, "p3")
		if Global.players > 3:
			await set_region(Global.p4_selection, "p4")
	
func _physics_process(delta):
	zoom()
	camera_move()
	
func zoom():
	if Input.is_action_just_released("wheel up"):
		if $Regions/Camera2D.zoom.x < 6:
			$Regions/Camera2D.zoom.x += 0.25
			$Regions/Camera2D.zoom.y += 0.25
	if Input.is_action_just_released("wheel down"):
		if $Regions/Camera2D.zoom.x >0.5:
			$Regions/Camera2D.zoom.x -= 0.25
			$Regions/Camera2D.zoom.y -= 0.25

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
	
	if $Regions/Camera2D.offset.x > 150:
		$Regions/Camera2D.offset.x = 150
	if $Regions/Camera2D.offset.x < -150:
		$Regions/Camera2D.offset.x = -150
	if $Regions/Camera2D.offset.y > 150:
		$Regions/Camera2D.offset.y = 150
	if $Regions/Camera2D.offset.y < -150:
		$Regions/Camera2D.offset.y = -150
	
func load_regions():
	var image = mapImage.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var regions_dict = import_file("res://regions.txt")
	
	for region_color in regions_dict:
		var region = load("res://Scenes/Regions_Area.tscn").instantiate()
		region.region_name = regions_dict[region_color]
		region.set_name(regions_dict[region_color])
		region.Owner = "region_owner"
		get_node("Regions").add_child(region)
		
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
	else:
		print("Region not found: " + region_name)
	await timer()
		
func set_region(selection, player):
	var Northland_Owned = false
	var Auckland_Owned = false
	var Waikato_Owned = false
	var BayOfPlenty_Owned = false
	var Taranaki_Owned = false
	var HawkesBay_Owned = false
	
	if selection == 0:
		await change_owner("Far North", player)
		await change_owner("Whangarei", player)
		await change_owner("Kaipara", player)
	elif selection == 1:
		await change_owner("North Auckland", player)
		await change_owner("Central Auckland", player)
		await change_owner("South Auckland", player)
		await change_owner("West Auckland", player)
		await change_owner("Coromandel", player)
	elif selection == 2:
		await change_owner("Gisborne", player)
		await change_owner("Opotiki", player)
		await change_owner("Whakatane", player)
		await change_owner("Rotorua", player)
		await change_owner("Tauranga", player)
	elif selection == 3:
		await change_owner("North Waikato", player)
		await change_owner("Hauraki", player)
		await change_owner("Hamilton",player)
		await change_owner("Waitomo", player)
		await change_owner("Taupo", player)
		await change_owner("Desert Road", player)
	elif selection == 4:
		await change_owner("South Taranaki", player)
		await change_owner("Whanganui", player)
		await change_owner("New Plymouth", player)
		await change_owner("Stratford", player)
		await change_owner("Ruapehu", player)
	elif selection == 5:
		await change_owner("Central Hawke's Bay", player)
		await change_owner("Hastings", player)
		await change_owner("Napier", player)
		await change_owner("Wairoa", player)
	elif selection == 6:
		await change_owner("Wellington", player)
		await change_owner("South Wairarapa", player)
		await change_owner("Masterton", player)
		await change_owner("Tararua Region", player)
		await change_owner("Palmerston North", player)
		await change_owner("Kapiti Coast", player)
		await change_owner("North Manawatu", player)
	elif selection == 7:
		await change_owner("Tasman", player)
		await change_owner("Marlbrough", player)
		await change_owner("Nelson", player)
		await change_owner("Kaikoura", player)
	elif selection == 8:
		await change_owner("Southern West Coast", player)
		await change_owner("Hokitika", player)
		await change_owner("Greymouth", player)
	elif selection == 9:
		await change_owner("Hurunui", player)
		await change_owner("Christchurch", player)
		await change_owner("Waimakariri", player)
		await change_owner("Selwyn", player)
		await change_owner("Ashburton", player)
		await change_owner("Waitaki", player)
	elif selection == 10:
		await change_owner("Queenstown", player)
		await change_owner("Wanaka", player)
		await change_owner("Otago", player)
		await change_owner("Dunedin", player)
	elif selection == 11:
		await change_owner("Stewart Island", player)
		await change_owner("Invercargill", player)
		await change_owner("Fiordland", player)

func timer():
	await get_tree().create_timer(0.1).timeout
