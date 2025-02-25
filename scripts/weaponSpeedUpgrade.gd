extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.projectile_speed < 600:
		purchase(body)
		queue_free()
func purchase(body):
	body.projectile_speed += 10
	print(body.projectile_speed)
