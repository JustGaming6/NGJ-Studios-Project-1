extends Sprite2D

var players = 0
var p1_selection = " "
var p2_selection = " "
var p3_selection = " "
var p4_selection = " "
var region_owner = " "
var region_name = " "
var turn = 1

var p1_income = 0
var p2_income = 0
var p3_income = 0
var p4_income = 0

var p1_bal = 0
var p2_bal = 0
var p3_bal = 0
var p4_bal = 0

var p1_moral = 50
var p2_moral = 50
var p3_moral = 50
var p4_moral = 50

var p1_manpower = 0
var p2_manpower = 0
var p3_manpower = 0
var p4_manpower = 0

var p1_territories = 0
var p2_territories = 0
var p3_territories = 0
var p4_territories = 0

var deployment_phase = false
var tutorial = false
var balance_mode = false
var region_clicked = false
var troops_region_name
var nuke_deployment = false

var attack_region = "blank"
var defense_region = "blank"
var region_info_clicked = "blank"

var winner 

func _onready():
	Global.players = 0
