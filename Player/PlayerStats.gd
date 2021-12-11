extends Node


onready var panelContainer = $DeathUI/PanelContainer


const titleScreen = preload("res://Menus/TitleScreen/TitleScreen.tscn")

const Pistol = preload("res://Player/Weapons/Pistol.tscn")


const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
const RocketLauncher = preload("res://Player/Weapons/RocketLauncher.tscn")
const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
const Sword = preload("res://Player/Weapons/Sword.tscn")

onready var unequiped_weapons = [HeavyPistol, MachineGun, RocketLauncher, SpreadGun]
#onready var unequiped_weapons = [HeavyPistol]

#var equiped_weapons = []
var weapons = [Sword,Pistol]
var all_weapons = [Sword,Pistol, HeavyPistol, MachineGun, RocketLauncher, SpreadGun]
var ammos = [null]
var weapon_ammo_array = [weapons, ammos]

var sword = 1
var pistol = 1
var heavyPistol = 0
var machineGun = 0
var rocketLauncher = 0
var spreadGun = 0

func reset_weapons():
	sword = 1
	pistol = 1
	heavyPistol = 0
	machineGun = 0
	rocketLauncher = 0
	spreadGun = 0

#equiped weapon ammo
var pistolAmmo = 0
var heavyPistolAmmo = 0
var machineGunAmmo = 0
var rocketLaucherAmmo = 0
var spreadGunAmmo = 0

#weaponManager
#var current_weapon_index = -1
var equip_weapon_index = 1


export (int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

export (int) var max_guts = 25 setget set_max_guts
var guts = max_guts setget set_guts
signal guts_changed(value)
signal max_guts_changed(value)




func _ready():
	reset_health()
#	equiped_weapons.append(Pistol.instance()) 


func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_max_guts(value):
	max_guts = value
	self.guts = guts
	emit_signal("max_guts_changed", max_guts)


func set_health(value):
	health = value
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_guts(value):
	guts = value
	emit_signal("guts_changed", guts)
	if guts > max_guts * 4:
		guts = max_guts * 4


func reset_health():
	self.health = max_health

func get_health_pickups():
	return 1


func _on_PlayerStats_no_health():
	reset_game_globals()
	panelContainer.visible = true


func reset_game_globals():
	Globals.floor_num = 0
	reset_weapons()
	PlayerStats.guts = max_guts


func pick_random_weapon():
	unequiped_weapons.shuffle()
	return unequiped_weapons[0]
	
func remove_from_unequiped_pool(weapon):
	unequiped_weapons.erase(weapon)


func _on_Button_pressed():
	get_tree().change_scene_to(titleScreen)
	panelContainer.visible = false
	reset_health()
	Globals.floor_num = 0
