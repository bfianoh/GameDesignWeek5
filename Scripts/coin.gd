extends Area2D

#when player touches coin make it disappear and increase player coin counter
func _on_body_entered(body: Node2D) -> void:
	purchase(body)
	
func purchase(body):
	body.coin_count += 5
	print(body.coin_count)
	queue_free()
