extends Area2D

#when player touches weapon upgrade make it disappear and increase player weapon strength
func _on_body_entered(body: Node2D) -> void:
	purchase(body)

func purchase(body):
	body.damage += 5
	print(body.damage)
	queue_free()
