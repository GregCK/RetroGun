extends KinematicBody2D


export var healthup = 1

const HealthPickupEffect = preload("res://Effects/HealthPickupEffect.tscn")

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	if player != null:
		var vec_to_player = get_vector_to_player()
		move_and_slide(vec_to_player)


func _on_Hurtbox_area_entered(area):
	var player = area.get_parent()
	if player.name == "Player":
		PlayerStats.health += healthup
		spawn_effect()
		queue_free()
	else:
		push_error("area.parent should be the player")


func spawn_effect():
	var effect = HealthPickupEffect.instance()
	get_parent().add_child(effect)
	effect.position = self.position
	


func attract(p):
	player = p


func get_vector_to_player():
	if player != null:
		var player_pos = player.position
		var my_pos = position
		var difference:Vector2 = player_pos - my_pos
		return difference
	return null
