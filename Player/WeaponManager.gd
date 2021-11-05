extends Position2D

const Pistol = preload("res://Player/Weapons/Pistol.tscn")
const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
const RocketLauncher = preload("res://Player/Weapons/RocketLauncher.tscn")
const Sword = preload("res://Player/Weapons/Sword.tscn")

onready var weaponLabel = $CanvasLayer/WeaponLabel
onready var ammoLabel = $CanvasLayer/AmmoLabel

#var weapons = [Pistol, HeavyPistol, MachineGun, SpreadGun, RocketLauncher, Sword]
#var weapons = [Pistol]
var weapons = []
var all_weapons = []
#var equiped_weapons = []
var weapon
#var current_weapon = -1



# Called when the node enters the scene tree for the first time.
func _ready():
#	instance each weapon in weapons
	for i in PlayerStats.weapons:
		var gun = i.instance()
		weapons.append(gun)
		add_child(gun)
		if gun.has_signal("ammo_changed"):
			gun.connect("ammo_changed", self, "update_ammoLabel")

	for weap in weapons:
		weap.set_visible(false)


#	instance each weapon in weapons
	for i in PlayerStats.all_weapons:
		var gun = i.instance()
		all_weapons.append(gun)
		add_child(gun)
		if gun.has_signal("ammo_changed"):
			gun.connect("ammo_changed", self, "update_ammoLabel")

	for weap in all_weapons:
		weap.set_visible(false)

	
	if PlayerStats.current_weapon_index == -1:
#		swap_weapons()
		equip_weapon(1)
	else:
#		set and make visible weapon
		if PlayerStats.current_weapon_index < weapons.size():
			weapon = weapons[PlayerStats.current_weapon_index]
			weapon.set_visible(true)
			weaponLabel.text = weapon.weapon_name
			ammoLabel.text = str(weapon.ammo)
		else:
			push_error("current_weapon is out of bounds")
	
	pass


func _process(delta):
#	if Input.is_action_just_pressed("swap_weapon"):
#		swap_weapons()
	
	
	if weapon != null:
		weapon.handle_input()

func _input(event):
	if event.is_action_pressed("1"):
		equip_weapon(0)
	elif event.is_action_pressed("2"):
		equip_weapon(1)
	elif event.is_action_pressed("3"):
		equip_weapon(2)
	elif event.is_action_pressed("4"):
		equip_weapon(3)
	elif event.is_action_pressed("5"):
		equip_weapon(4)
	elif event.is_action_pressed("6"):
		equip_weapon(5)
	elif event.is_action_pressed("7"):
		equip_weapon(6)
	elif event.is_action_pressed("8"):
		equip_weapon(7)
	elif event.is_action_pressed("9"):
		equip_weapon(8)

func equip_weapon(w):
#	make sure the weapon is valid
	if w >= all_weapons.size() or w < 0:
		return
	match w:
		0:
			if PlayerStats.sword < 1:
				return
		1:
			if PlayerStats.pistol < 1:
				return
		2:
			if PlayerStats.heavyPistol < 1:
				return
		3:
			if PlayerStats.machineGun < 1:
				return
		4:
			if PlayerStats.rocketLauncher < 1:
				return
		5:
			if PlayerStats.spreadGun < 1:
				return
	
	
#	equip the weapon
	if weapon:
		weapon.set_visible(false)
	
	PlayerStats.current_weapon_index = w
#	weapon = weapons[w]
	weapon = all_weapons[w]
	weapon.set_visible(true)

	weaponLabel.text = weapon.weapon_name
	if weapon.ammo != null:
		ammoLabel.text = str(weapon.ammo)
	else:
		ammoLabel.text = ""




#func swap_weapons():
#	if weapon:
#		weapon.set_visible(false)
#
#
#	PlayerStats.current_weapon_index += 1
#	if PlayerStats.current_weapon_index >= weapons.size():
#		PlayerStats.current_weapon_index = 0
#	weapon = weapons[PlayerStats.current_weapon_index]
#
#	weapon.set_visible(true)
#
#	weaponLabel.text = weapon.weapon_name
#	if weapon.ammo != null:
#		ammoLabel.text = str(weapon.ammo)
#	else:
#		ammoLabel.text = ""


#func add_weapon(new_weapon):
#	var matching_weapon = get_matching_weapon(new_weapon)
#	if matching_weapon == null:
#		PlayerStats.weapons.append(new_weapon)
#		var gun = new_weapon.instance()
#		weapons.append(gun)
#		call_deferred("add_child", gun)
#		gun.call_deferred("set_visible", false)
#
#		if gun.has_signal("ammo_changed"):
#			gun.connect("ammo_changed", self, "update_ammoLabel")
#
##		
#	else:
##		give them more ammo
#
#		var new_weapon_ammo = new_weapon.instance().ammo
#		if new_weapon_ammo != null:
##			find weapn of same name
#			matching_weapon.ammo += new_weapon_ammo
##			update_ammoLabel()

func add_weapon(new_weapon):
	var name = new_weapon.instance().name
	match name:
		"Sword":
			pass
		"Pistol":
			pass
		"HeavyPistol":
			PlayerStats.heavyPistol += 1
			$CanvasLayer/WeaponIcons/HeavyPistol.set_modulate(Color(1,1,1,1))
		"MachineGun":
			PlayerStats.machineGun += 1
			$CanvasLayer/WeaponIcons/MachineGun.set_modulate(Color(1,1,1,1))
		"RocketLauncher":
			PlayerStats.rocketLauncher += 1
			$CanvasLayer/WeaponIcons/RocketeLauncher.set_modulate(Color(1,1,1,1))
		"SpreadGun":
			PlayerStats.spreadGun += 1
			$CanvasLayer/WeaponIcons/SpreadGun.set_modulate(Color(1,1,1,1))

func get_matching_weapon(new_weapon):
	var new_weapon_name = new_weapon.instance().weapon_name
	for w in weapons:
		var w_weapon_name = w.weapon_name
		if w_weapon_name == new_weapon_name:
			return w
	return null


func update_ammoLabel(ammo):
	ammoLabel.text = str(ammo)

#func _input(event):
#	if weapon != null:
#		weapon.handle_input()
