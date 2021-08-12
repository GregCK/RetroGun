extends Position2D

#const Pistol = preload("res://Player/Weapons/Pistol.tscn")
#const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
#const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
#const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
#const RocketLauncher = preload("res://Player/Weapons/RocketLauncher.tscn")
#const Sword = preload("res://Player/Weapons/Sword.tscn")

onready var weaponLabel = $CanvasLayer/WeaponLabel


#var weapons = [Pistol, HeavyPistol, MachineGun, SpreadGun, RocketLauncher, Sword]
#var weapons = [Pistol]
var weapons = []
var equiped_weapons = []
var weapon
var current_weapon = -1



# Called when the node enters the scene tree for the first time.
func _ready():
	current_weapon = PlayerStats.current_weapon_index
	
	for i in PlayerStats.weapons:
		var gun = i.instance()
		weapons.append(gun)
		add_child(gun)
	
	var i = 0
	for weap in weapons:
		weap.set_visible(false)
	
	if current_weapon == -1:
		swap_weapons()
	else:
#		set and make visible weapon
		if current_weapon < weapons.size():
			weapon = weapons[current_weapon]
			weapon.set_visible(true)
			weaponLabel.text = weapon.weapon_name
		else:
			push_error("current_weapon is out of bounds")
	
	pass


func _process(delta):
	if Input.is_action_just_pressed("swap_weapon"):
		swap_weapons()
	
	if weapon != null:
		weapon.handle_input()

func swap_weapons():
	if weapon:
		weapon.set_visible(false)
	
	
	current_weapon += 1
	PlayerStats.current_weapon_index = current_weapon
	if current_weapon >= weapons.size():
		current_weapon = 0
	weapon = weapons[current_weapon]
	
	weapon.set_visible(true)
	
	weaponLabel.text = weapon.weapon_name


func add_weapon(new_weapon):
	PlayerStats.weapons.append(new_weapon)
	var gun = new_weapon.instance()
	weapons.append(gun)
#	add_child(gun)
	call_deferred("add_child", gun)
#	gun.set_visible(false)
	gun.call_deferred("set_visible", false)
	
	
	
	

#func _input(event):
#	if weapon != null:
#		weapon.handle_input()
