extends Node2D

const soundEffect = preload("res://Effects/WeaponPickupSoundEffect.tscn")

onready var sprite = $Sprite

#const my_weapon = preload("res://Player/Weapons/HeavyPistol.tscn")
var my_weapon

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	
	if PlayerStats.unequiped_weapons.size() > 0:
		my_weapon = PlayerStats.pick_random_weapon()
		var weaponSprite = my_weapon.instance().get_node("WeaponSprite")
		var spriteResource = weaponSprite.get_texture()
		sprite.set_texture(spriteResource)
		
		
	else:
		print("all weapons equiped")
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	var player = area.get_parent()
	if player.name == "Player":
		var weaponManager = player.get_node("WeaponManager")
		weaponManager.add_weapon(my_weapon)
#		PlayerStats.remove_from_unequiped_pool(my_weapon)
		spawn_sound_effect()
		queue_free()
	else:
		push_error("area.parent should be the player")

func spawn_sound_effect():
	var e = soundEffect.instance()
	parent.add_child(e)
