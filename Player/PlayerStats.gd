extends Node

const titleScreen = preload("res://TitleScreen/TitleScreen.tscn")

const Pistol = preload("res://Player/Weapons/Pistol.tscn")


const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
const RocketLauncher = preload("res://Player/Weapons/RocketLauncher.tscn")
const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
const Sword = preload("res://Player/Weapons/Sword.tscn")
#onready var unequiped_weapons = [HeavyPistol, MachineGun, RocketLauncher, SpreadGun, Sword]
onready var unequiped_weapons = [HeavyPistol]

var weapons = [Pistol]
var ammos = [null]
var weapon_ammo_array = [weapons, ammos]
var current_weapon_index = -1

export (int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)


func _ready():
	self.health = max_health
#	unequiped_weapons = [HeavyPistol, MachineGun, RocketLauncher, SpreadGun, Sword]

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")






func _on_PlayerStats_no_health():
	health = max_health
	Globals.floor_num = 1
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(titleScreen)


func pick_random_weapon():
	unequiped_weapons.shuffle()
	return unequiped_weapons[0]
	
func remove_from_unequiped_pool(weapon):
	unequiped_weapons.erase(weapon)
