extends KinematicBody2D

signal state_changed(new_state)

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const PortalSpawner = preload("res://Enemies/PortalSpawner.tscn")

onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var stats = $Stats
onready var playerCast = null

var parent = null
var player : Player = null

var path: Array = [] #contains destination points
var levelNavigation: Navigation2D = null

var velocity = Vector2.ZERO

func _ready():
	parent = get_parent()



func _on_Hurtbox_area_entered(area):
	blinkAnimationPlayer.play("Start")
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	var effect = EnemyDeathEffect.instance()
	effect.set_global_position(get_global_position())
	parent.add_child(effect)
	
	
	var enemies = get_tree().get_nodes_in_group("enemies").size()
	
	spawn_portal_spawner()
	
	queue_free()
	

func spawn_portal_spawner():
	var portal = PortalSpawner.instance()
	portal.set_world(parent)
	parent.call_deferred("add_child", portal)
	portal.position = position

#func can_see_player():
#	if player != null:
#		var player_pos = player.get_global_position()
#		var ray_pos = playerCast.get_global_position()
#		var ray_vector = player_pos - ray_pos
#		playerCast.set_cast_to(ray_vector)
#		var coll = playerCast.get_collider()
#		if playerCast.is_colliding() and coll.is_in_group("player"):
#			return true
#		else:
#			return false

func get_distance_to_player():
	if player != null:
		var difference:Vector2 = get_vector_to_player()
		var length = difference.length()
		return length
	return null

func get_vector_to_player():
	if player != null:
		var player_pos = player.position
		var my_pos = position
		var difference:Vector2 = player_pos - my_pos
		return difference
	return null

func can_see_player():
	if player != null:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, player.position, [self], playerCast.collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				return true
			else:
				return false

func can_smell_player():
	var scents = get_tree().get_nodes_in_group("scents")
	var i = scents.size() - 1
	while i >= 0:
		playerCast.cast_to = (scents[i].position - position)
		playerCast.force_raycast_update()
		
		if !playerCast.is_colliding():
			return playerCast.cast_to.normalized()
		i = i - 1
	
	return null

func navigate(speed):
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * speed
		pass
	
#	if reached destination, remove point from path
	if global_position == path[0]:
		path.pop_front()

func generate_path_to_player():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		return path


func set_player(p):
	player = p
	
func move():
	velocity = move_and_slide(velocity)
