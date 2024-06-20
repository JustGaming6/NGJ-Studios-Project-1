extends Node2D

@onready var mapImage = $Sprite2D

var camera_speed = 10
var zoom_speed = 0.25
var loading_screen = false

var region_info
var region
var troops_label
var p_turn
var purchase_valid
var true_player = false
var valid_attack

func _ready():
	#Set the loading screen
	$BlankScreens/p1Screen.hide()
	$BlankScreens/Button.hide()
	loading_screen = true
	load_screen("loading")
	load_regions()
	#Seting owners of the regions
	await set_bot()
	await set_region(Global.p1_selection, "p1")
	await set_region(Global.p2_selection, "p2")
	if Global.players > 2:
		await set_region(Global.p3_selection, "p3")
		if Global.players > 3:
			await set_region(Global.p4_selection, "p4")
	loading_screen = false #Telling the code to exit the loading screen
	true_player = false
	var hamilton_label = get_node("Regions").get_node("Hamilton").get_node("label") #Adjdusting hamilton label to be centre
	hamilton_label.position.x += 10
	load_screen("game") #Load game screen
	load_screen("p1") #Starting Player 1's turn
	turn("p1")                                                                                                                                                                                                                                                                                                        
	
func _physics_process(delta):
	#Input for testing
	if Input.is_action_just_pressed("unlimited_power"):
		Global.p1_bal = 10000000000
		Global.p1_manpower = 100000000
		Global.p2_income = 0
		Global.p3_income = 0
		Global.p4_income = 0
	if loading_screen == false: # If not on the loading screen run the camera movement functions
		zoom()
		camera_move()
		
func change_global_turn():
	match Global.turn:
		1:
			p_turn = "p1"
		2:
			p_turn = "p2"
		3:
			p_turn = "p3"
		4:
			p_turn = "p4"


func purchase(cost, turn): #Checking if a troop purchase is valid (e.g. has enough money)
	purchase_valid = false
	match turn:
		"p1":
			if Global.p1_bal >= cost:
				purchase_valid = true
				Global.p1_bal -= cost
		"p2":
			if Global.p2_bal >= cost:
				purchase_valid = true
				Global.p2_bal -= cost
		"p3":
			if Global.p3_bal >= cost:
				purchase_valid = true
				Global.p3_bal -= cost
		"p4":
			if Global.p4_bal >= cost:
				purchase_valid = true
				Global.p4_bal -= cost
		
func _process(delta):
	if Global.region_clicked == true: #Add troop to clicked region
		Global.region_clicked = false
		change_global_turn()
		var region = get_node("Regions").get_node(Global.troops_region_name)
		if str(region.Owner) == p_turn:
			purchase(200, p_turn)
			if purchase_valid == true:
				region.Troops += 1
				Global.region_clicked = false
				var troops_label = get_node("Regions").get_node(Global.troops_region_name).get_node("label")
				troops_label.set_text(str(region.Troops))
				
	if Global.attack_region != "blank" and Global.defense_region != "blank": #CHeck if the player has chosen to attack
		attack(Global.attack_region, Global.defense_region)
		Global.defense_region = "blank"
		Global.attack_region = "blank"

func attack(attack, defense): #Calculates the outcome of an attack
	var troop_loss_max
	var attack_node = get_node("Regions").get_node(attack)
	var defense_node = get_node("Regions").get_node(defense)
	var attack_label = get_node("Regions").get_node(attack).get_node("label")
	var defense_label = get_node("Regions").get_node(defense).get_node("label")
	attack_check(attack, defense, attack_node.Owner)
	if attack_node.Troops > 1 and valid_attack == true:
		var chance = int(attack_node.Troops) / int(defense_node.Troops)
		var rng = RandomNumberGenerator.new()
		var result = int(rng.randf_range(0,9))
		var outcome
		if chance <= 0.25:
			outcome = "L"
			troop_loss_max = 0.1
		elif chance <= 0.5:
			match result:
				0,1,2,3,4,5,6,7,8:
					outcome = "L"
					troop_loss_max = 0.1
				9:
					outcome = "W"
					troop_loss_max = 0.9
		elif chance <= 0.6:
			match result:
				0,1,2,3,4,5,6,7:
					outcome = "L"
					troop_loss_max = 0.2
				8,9:
					outcome = "W"
					troop_loss_max = 0.9
		elif chance <= 1:
			match result:
				0,1,2,3,4,5,6:
					outcome = "L"
					troop_loss_max = 0.3
				7,8,9:
					outcome = "W"
					troop_loss_max = 0.8
		elif chance <= 1.25:
			match result:
				0,1,2,3,4:
					outcome = "L"
					troop_loss_max = 0.4
				5,6,7,8,9:
					outcome = "W"
					troop_loss_max = 0.7
		elif chance <= 1.5:
			match result:
				0,1,2:
					outcome = "L"
					troop_loss_max = 0.7
				3,4,5,6,7,8,9:
					outcome = "W"
					troop_loss_max = 0.7
		elif chance <= 2:
			match result:
				0,1:
					outcome = "L"
					troop_loss_max = 0.8
				2,3,4,5,6,7,8,9:
					outcome = "W"
					troop_loss_max = 0.5
		elif chance <3:
			match result:
				0:
					outcome = "L"
					troop_loss_max = 0.9
				1,2,3,4,5,6,7,8,9:
					outcome = "W"
					troop_loss_max = 0.25
		elif chance >= 3:
			outcome = "W"
			troop_loss_max = 0.1
			if chance > 3.5:
				troop_loss_max = 0
		var troop_loss = rng.randf_range(0, troop_loss_max)
		print(troop_loss)
		match outcome:
			"W":
				defense_node.Troops = attack_node.Troops - 1
				attack_node.Troops = 1
				troop_loss = defense_node.Troops * troop_loss
				defense_node.Troops -= troop_loss
				defense_node.Troops = round(int(defense_node.Troops))
				if int(defense_node.Troops) < 1:
					defense_node.Troops = 1
				change_owner(str(defense), str(attack_node.Owner))
			"L":
				attack_node.Troops = 1
				troop_loss = defense_node.Troops * troop_loss
				defense_node.Troops -= troop_loss
				defense_node.Troops = round(int(defense_node.Troops))
				if int(defense_node.Troops) < 1:
					defense_node.Troops = 1
		attack_label.set_text(str(attack_node.Troops))
		defense_label.set_text(str(defense_node.Troops))

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
	var regions_dict = import_file("res://regions.txt")
	
	for region_color in regions_dict:
		region = load("res://Scenes/Regions_Area.tscn").instantiate()
		region_info = regions_dict[region_color]
		region.region_name =  region_info[0]
		region.set_name(region_info[0])
		region.Owner =  "region_owner"
		region.Income = region_info[1]
		region.Manpower = region_info[2]
		region.Troops = region_info[3]
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
		match region.Owner: #Removing the regions Income and Manpiwer from the current regions owner
			"p1":
				Global.p1_income -= region.Income
				Global.p1_manpower -= region.Manpower
			"p2":
				Global.p2_income -= region.Income
				Global.p2_manpower -= region.Manpower
			"p3":
				Global.p3_income -= region.Income
				Global.p3_manpower -= region.Manpower
			"p4":
				Global.p4_income -= region.Income
				Global.p4_manpower-= region.Manpower
		
		region.Owner = new_owner
		Global.region_owner = region.Owner
		Global.region_name = region_name
		print(region_name + ": " + region.Owner)
		
		if true_player == true: #Giving the real players there troops at the start of the game
			match new_owner:
				"p1":
					region.Troops = 1
				"p2":
					region.Troops = 2
				"p3":
					region.Troops = 2
				"p4":
					region.Troops = 3
			var label = get_node("Regions").get_node(region_name).get_node("label")
			label.set_text(str(region.Troops))
		
		match new_owner: #Add the Regions Income and Manpower to the new region owner
			"p1":
				Global.p1_income += region.Income
				Global.p1_manpower += region.Manpower
			"p2":
				Global.p2_income += region.Income
				Global.p2_manpower += region.Manpower
			"p3":
				Global.p3_income += region.Income
				Global.p3_manpower += region.Manpower
			"p4":
				Global.p4_income += region.Income
				Global.p4_manpower += region.Manpower
	else:
		print("Region not found: " + region_name)
	await timer()
	
func turn(player):
	Global.deployment_phase = true
	$TroopSelection.show()
	load_screen("game")
	load_screen(player)
	match player: #Adding the players income to their balance
		"p1":
			Global.p1_bal += Global.p1_income
		"p2":
			Global.p2_bal += Global.p2_income
		"p3":
			Global.p3_bal += Global.p3_income
		"p4":
			Global.p4_bal += Global.p4_income

func set_region(selection, player): #Seting the regions at the start of the game
	match player:
		"p1", "p2", "p3", "p4":
			true_player = true
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

func timer(): #Timer for setting regions
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

func attack_check(attack, defense, attack_player): #Checking if the defense region is next to the attack region
	var turn
	valid_attack = false
	match Global.turn:
		1:
			turn = "p1"
		2:
			turn = "p2"
		3:
			turn = "p3"
		4:
			turn = "p4"
	if turn == attack_player:
		match attack:
			"Far North":
				match defense:
					"Whangarei", "Kaipara":
						valid_attack = true
			"Whangarei":
				match defense:
					"Far North", "Kaipara":
						valid_attack = true
			"Kaipara":
				match defense:
					"Far North", "Whangarei", "North Auckland":
						valid_attack = true
			"North Auckland":
				match defense:
					"Kaipara", "Central Auckland":
						valid_attack = true
			"Central Auckland":
				match defense:
					"North Auckland", "West Auckland", "South Auckland":
						valid_attack = true
			"West Auckland":
				match defense:
					"Central Auckland", "North Waikato", "South Auckland":
						valid_attack = true
			"South Auckland":
				match defense:
					"Central Auckland", "West Auckland", "Coromandel", "North Waikato", "Hauraki":
						valid_attack = true
			"Coromandel":
				match defense:
					"Hauraki", "Tauranga", "South Auckland":
						valid_attack = true
			"Hauraki":
				match defense:
					"South Auckland", "North Waikato", "Hamilton", "Tauranga", "Coromandel":
						valid_attack = true
			"North Waikato":
				match defense:
					"South Auckland", "West Auckland", "Hamilton", "Hauraki", "Waitomo":
						valid_attack = true
			"Hamilton":
				match defense:
					"North Waikato", "Rotorua", "Tauranga", "Hauraki", "Waitomo", "Taupo":
						valid_attack = true
			"Waitomo":
				match defense:
					"North Waikato", "Hamilton", "Taupo", "Ruapehu", "New Plymouth":
						valid_attack = true
			"Taupo":
				match defense:
					"Waitomo", "Hamilton", "Rotorua", "Whakatane", "Wairoa", "Hastings", "Desert Road", "Ruapehu":
						valid_attack = true
			"Desert Road":
				match defense:
					"Taupo", "Hastings", "Whanganui", "Ruapehu":
						valid_attack = true
			"Tauranga":
				match defense:
					"Coromandel", "Hauraki", "Hamilton", "Rotorua", "Whakatane":
						valid_attack = true
			"Rotorua":
				match defense:
					"Hamilton", "Tauranga", "Whakatane", "Taupo":
						valid_attack = true
			"Whakatane":
				match defense:
					"Rotorua", "Tauranga", "Wairoa", "Taupo", "Gisborne", "Opotiki":
						valid_attack = true
			"Opotiki":
				match defense:
					"Whakatane", "Gisborne":
						valid_attack = true
			"Gisborne":
				match defense:
					"Opotiki", "Whakatane", "Wairoa":
						valid_attack = true
			"Wairoa":
				match defense:
					"Gisborne", "Whakatane", "Hastings", "Taupo", "Napier":
						valid_attack = true
			"Hastings":
				match defense:
					"Wairoa", "Central Hawke's Bay", "Whanganui", "Taupo", "Napier", "Desert Road":
						valid_attack = true
			"Napier":
				match defense:
					"Central Hawke's Bay", "Hastings", "Wairoa":
						valid_attack = true
			"Central Hawke's Bay":
				match defense:
					"Napier", "Hastings", "North Manawatu", "Tararua Region":
						valid_attack = true
			"Ruapehu":
				match defense:
					"Waitomo", "Taupo", "Desert Road", "Stratford", "New Plymouth":
						valid_attack = true
			"New Plymouth":
				match defense:
					"Waitomo", "Ruapehu", "South Taranaki", "Stratford":
						valid_attack = true
			"Stratford":
				match defense:
					"Ruapehu", "New Plymouth", "South Taranaki", "Whanganui":
						valid_attack = true
			"South Taranaki":
				match defense:
					"New Plymouth", "Stratford", "Whanganui":
						valid_attack = true
			"Whanganui":
				match defense:
					"South Taranaki", "Stratford", "Desert Road", "Hastings", "North Manawatu":
						valid_attack = true
			"North Manawatu":
				match defense:
					"Whanganui", "Central Hawke's Bay", "Tararua Region", "Palmerston North", "Kapiti Coast":
						valid_attack = true
			"Palmerston North":
				match defense:
					"North Manawatu", "Kapiti Coast", "Masterton", "Tararua Region":
						valid_attack = true
			"Tararua Region":
				match defense:
					"Central Hawke's Bay", "North Manawatu", "Masterton", "Palmerston North":
						valid_attack = true
			"Masterton":
				match defense:
					"Tararua Region", "Palmerston North", "Kapiti Coast", "South Wairarapa":
						valid_attack = true
			"Kapiti Coast":
				match defense:
					"North Manawatu", "Palmerston North", "Masterton", "South Wairarapa", "Wellington":
						valid_attack = true
			"Wellington":
				match defense:
					"Kapiti Coast", "South Wairarapa", "Marlbrough":
						valid_attack = true
			"South Wairarapa":
				match defense:
					"Kapiti Coast", "Wellington", "Masterton":
						valid_attack = true
			"Marlbrough":
				match defense:
					"Nelson", "Tasman", "Hurunui", "Kaikoura", "Wellington":
						valid_attack = true
			"Tasman":
				match defense:
					"Nelson", "Marlbrough", "Hurunui", "Greymouth":
						valid_attack = true
			"Nelson":
				match defense:
					"Tasman", "Marlbrough":
						valid_attack = true
			"Kaikoura":
				match defense:
					"Hurunui", "Marlbrough":
						valid_attack = true
			"Waimakariri":
				match defense:
					"Hurunui", "Selwyn", "Christchurch":
						valid_attack = true
			"Selwyn":
				match defense:
					"Christchurch", "Waimakariri", "Hurunui", "Greymouth","Hokitika", "Ashburton":
						valid_attack = true
			"Hurunui":
				match defense:
					"Kaikoura", "Marlbrough", "Tasman", "Greymouth","Selwyn", "Waimakariri":
						valid_attack = true
			"Ashburton":
				match defense:
					"Selwyn", "Hokitika", "Southern West Coast", "Waitaki":
						valid_attack = true
			"Waitaki":
				match defense:
					"Ashburton", "Wanaka", "Southern West Coast", "Otago":
						valid_attack = true
			"Christchurch":
				match defense:
					"Waimakariri", "Selwyn":
						valid_attack = true
			"Greymouth":
				match defense:
					"Tasman", "Hurunui", "Selwyn", "Hokitika":
						valid_attack = true
			"Hokitika":
				match defense:
					"Greymouth", "Ashburton", "Selwyn", "Southern West Coast":
						valid_attack = true
			"Southern West Coast":
				match defense:
					"Hokitika", "Ashburton", "Waitaki", "Wanaka", "Fiordland":
						valid_attack = true
			"Fiordland":
				match defense:
					"Southern West Coast", "Wanaka", "Queenstown", "Invercargill":
						valid_attack = true
			"Stewart Island":
				match defense:
					"Invercargill":
						valid_attack = true
			"Wanaka":
				match defense:
					"Southern West Coast", "Waitaki", "Queenstown", "Fiordland", "Otago":
						valid_attack = true
			"Otago":
				match defense:
					"Wanaka", "Dunedin", "Waitaki", "Queenstown", "Invercargill":
						valid_attack = true
			"Dunedin":
				match defense:
					"Otago":
						valid_attack = true

func _on_button_pressed():
	load_screen("game")

func _on_turnbutton_pressed(): #Changing Turns
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

func _on_troopselection_button_pressed(): #Exiting Deployment phase
	Global.deployment_phase = false
	$TroopSelection.hide()
