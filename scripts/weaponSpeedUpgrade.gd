extends Area2D

func _on_body_entered(body: Node2D) -> void:
	purchase(body)
	queue_free()
func purchase(body):
	#prevent player projectile speed from getting too high
	if(body.projectile_speed < 600):
		body.projectile_speed += 10
	print(body.projectile_speed)
