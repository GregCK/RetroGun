extends Position2D

const Pistol = preload("res://Player/Weapons/Pistol.tscn")
const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
const Sword = preload("res://Player/Weapons/Sword.tscn")

onready var weaponLabel = $CanvasLayer/WeaponLabel

#var Weapons = [Pistol, HeavyPistol, MachineGun, SpreadGun, Sword]
var Weapons = [HeavyPistol,Sword]
var weapons = []
var weapon
var current_weapon = 0



# Called when the node enters the scene tree for the first time.
func _ready():
#	var pistol = Pistol.instance()
#	add_child(pistol)
	
#	var heavyPistol = HeavyPistol.instance()
#	add_child(heavyPistol)
	
	for i in Weapons:
		var gun = i.instance()
		weapons.append(gun)
		add_child(gun)
	
	weapon = weapons[current_weapon]
	weaponLabel.text = weapon.weapon_name


func _process(delta):
	if Input.is_action_just_pressed("swap_weapon"):
		swap_weapons()
	
	if weapon != null:
		weapon.handle_input()

func swap_weapons():
	current_weapon += 1
	if current_weapon >= weapons.size():
		current_weapon = 0
	weapon = weapons[current_weapon]
	
	weaponLabel.text = weapon.weapon_name

#func _input(event):
#	if weapon != null:
#		weapon.handle_input()
