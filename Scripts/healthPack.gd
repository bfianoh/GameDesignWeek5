extends Area2D
#when player touches health pack make pack dissappear and increase player's health
func _on_body_entered(body: Node2D) -> void:
	if body.health < 100:
		purchase(body)
		queue_free()


func purchase(body):
	body.health += 20
	print(body.health)
