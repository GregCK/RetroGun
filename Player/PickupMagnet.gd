extends Area2D



func _on_PickupMagnet_body_entered(body):
	if body.name == "SmallHealthPickup":
		body.attract(self.get_parent())
