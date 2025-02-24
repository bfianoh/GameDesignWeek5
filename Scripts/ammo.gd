extends Area2D

#when player touches ammo make it disappear and increase player ammo counter
func _on_body_entered(body: Node2D) -> void:
	purchase(body)
	queue_free()

func purchase(body):
	body.ammo += 5
	print(body.ammo)
