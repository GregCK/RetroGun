extends KinematicBody2D


onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var stats = $Stats



func _on_Hurtbox_area_entered(area):
	blinkAnimationPlayer.play("Start")
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	queue_free()
