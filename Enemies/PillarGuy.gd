extends KinematicBody2D


onready var blinkAnimationPlayer = $BlinkAnimationPlayer



func _on_Hurtbox_area_entered(area):
	blinkAnimationPlayer.play("Start")
