extends Position2D

#const Pistol = preload("res://Player/Weapons/Pistol.tscn")
#const HeavyPistol = preload("res://Player/Weapons/HeavyPistol.tscn")
#const MachineGun = preload("res://Player/Weapons/MachineGun.tscn")
#const SpreadGun = preload("res://Player/Weapons/SpreadGun.tscn")
#const RocketLauncher = preload("res://Player/Weapons/RocketLauncher.tscn")
#const Sword = preload("res://Player/Weapons/Sword.tscn")

onready var weaponLabel = $CanvasLayer/WeaponLabel
onready var ammoLabel = $CanvasLayer/AmmoLabel

#var weapons = [Pistol, HeavyPistol, MachineGun, SpreadGun, RocketLauncher, Sword]
#var weapons = [Pistol]
var weapons = []
var equiped_weapons = []
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

# add the already instanced weapon in equiped_weapons
#	for i in PlayerStats.equiped_weapons:
#		var gun = i
#		weapons.append(gun)
#		add_child(gun)
#		if gun.has_signal("ammo_changed"):
#			gun.connect("ammo_changed", self, "update_ammoLabel")
	

	for weap in weapons:
		weap.set_visible(false)
	
	if PlayerStats.current_weapon_index == -1:
		swap_weapons()
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
	if Input.is_action_just_pressed("swap_weapon"):
		swap_weapons()
	
	if weapon != null:
		weapon.handle_input()

func swap_weapons():
	if weapon:
		weapon.set_visible(false)
	
	
	PlayerStats.current_weapon_index += 1
	if PlayerStats.current_weapon_index >= weapons.size():
		PlayerStats.current_weapon_index = 0
	weapon = weapons[PlayerStats.current_weapon_index]
	
	weapon.set_visible(true)
	
	weaponLabel.text = weapon.weapon_name
	if weapon.ammo != null:
		ammoLabel.text = str(weapon.ammo)
	else:
		ammoLabel.text = ""


func add_weapon(new_weapon):
	var matching_weapon = get_matching_weapon(new_weapon)
	if matching_weapon == null:
		PlayerStats.weapons.append(new_weapon)
		var gun = new_weapon.instance()
		weapons.append(gun)
		call_deferred("add_child", gun)
		gun.call_deferred("set_visible", false)
		
		if gun.has_signal("ammo_changed"):
			gun.connect("ammo_changed", self, "update_ammoLabel")
	else:
#		give them more ammo
		
		var new_weapon_ammo = new_weapon.instance().ammo
		if new_weapon_ammo != null:
#			find weapn of same name
			matching_weapon.ammo += new_weapon_ammo
#			update_ammoLabel()
	
	

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
