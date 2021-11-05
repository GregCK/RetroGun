extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerStats.sword > 0:
		$Sword.set_modulate(Color(1,1,1,1))
	if PlayerStats.pistol > 0:
		$Pistol.set_modulate(Color(1,1,1,1))
	if PlayerStats.heavyPistol > 0:
		$HeavyPistol.set_modulate(Color(1,1,1,1))
	if PlayerStats.machineGun > 0:
		$MachineGun.set_modulate(Color(1,1,1,1))
	if PlayerStats.rocketLauncher > 0:
		$RocketeLauncher.set_modulate(Color(1,1,1,1))
	if PlayerStats.spreadGun > 0:
		$SpreadGun.set_modulate(Color(1,1,1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
