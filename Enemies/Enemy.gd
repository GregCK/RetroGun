extends KinematicBody2D

# warning-ignore:unused_signal
signal state_changed(new_state)

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const PortalSpawner = preload("res://Enemies/PortalSpawner.tscn")
const HealthPickup = preload("res://Objects/Pickups/HealthPickup.tscn")
const SmallHealthPickup = preload("res://Objects/Pickups/SmallHealthPickup.tscn")

onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var stats = $Stats
var softCollision
onready var playerCast = null

var parent = null
var player : Player = null

var path: Array = [] #contains destination points
var levelNavigation: Navigation2D = null

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var last_weapon_hit_by

func _ready():
	parent = get_parent()
	var fallAnimationPlayer = get_node_or_null("FallAnimationPlayer")
	if fallAnimationPlayer != null:
		fallAnimationPlayer.connect("animation_finished", self, "on_fall_animation_finished")
	else:
		pass



func _on_Hurtbox_area_entered(area):
	if not area.get("damage") == null:
#		area has damage variable
		last_weapon_hit_by = area.get_parent()

		blinkAnimationPlayer.play("Start")
		stats.health -= area.damage
		knockback = area.knockback_vector * 150
		
		
	else:
#		push_error("area did not have damage variable")
		pass
	pass

signal die
func _on_Stats_no_health():
	Globals.camera.frame_freeze(0.1, 0.35)
	
	var effect = EnemyDeathEffect.instance()
	effect.set_global_position(get_global_position())
	parent.add_child(effect)
	
	
	emit_signal("die", self)
	
	spawn_portal_spawner()
	spawn_health()
	queue_free()

func fall():
	$FallAnimationPlayer.play("Fall")

func on_fall_animation_finished(animation):
	stats.set_health(0)


func spawn_portal_spawner():
	var portal = PortalSpawner.instance()
	portal.set_world(parent)
	parent.call_deferred("add_child", portal)
	portal.position = position

func spawn_health():
	if last_weapon_hit_by != null and last_weapon_hit_by.name == "Sword":
		var health_pickups = PlayerStats.get_health_pickups()
	
		for i in health_pickups:
			var dot = SmallHealthPickup.instance()
			parent.call_deferred("add_child", dot)
			dot.position = position



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
				Globals.last_known_loc = player.global_position
				get_tree().call_group("enemies", "player_spotted")
				return true
			else:
				return false

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


#must be called to softcollide
#needs to move gradually to work correctly ie, navigate_gradual. 
#change velocity over time instead of setting it
func detect_softCollision(delta):
	if softCollision != null:
		if softCollision.is_colliding():
			velocity = velocity + (softCollision.get_push_vector() * delta * 400)
			if velocity.length() > 500:
				pass
			pass
	else:
#		softCollision var must be set in child's ready function
		push_error("softCollision is null")


func navigate(speed):
	if path.size() > 1:
		velocity = global_position.direction_to(path[1]) * speed
		pass
	
#	if reached destination, remove point from path
	if global_position == path[0]:
		path.pop_front()

func navigate_gradual(speed, delta, acceleration = 300):
	if path.size() > 1:
		velocity = velocity.move_toward(global_position.direction_to(path[1]) * speed, acceleration * delta)
	elif path.size() > 0:
		velocity = velocity.move_toward(global_position.direction_to(path[0]) * speed, acceleration * delta)
#	if reached destination, remove point from path
	if path.size() > 0 and global_position == path[0]:
		path.pop_front()

func generate_path_to_player():
	if levelNavigation != null and player != null:
		path = levelNavigation.get_simple_path(global_position, player.global_position, false)
		
#		should fix stutter bug
		if path.size() > 0 and global_position == path[0]:
			path.pop_front()
		return path

func generate_path_to_position(position):
	if levelNavigation != null:
		path = levelNavigation.get_simple_path(global_position, position, false)
		
#		should fix stutter bug
		if path.size() > 0 and global_position == path[0]:
			path.pop_front()
		return path


func set_player(p):
	player = p

func set_level_nav():
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	
func move():
	velocity = move_and_slide(velocity)
