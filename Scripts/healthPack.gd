extends Area2D

#when player touches health pack make pack dissappear and increase player's health
func _on_body_entered(body: Node2D) -> void:
	purchase(body)

func purchase(body):
	#[INCREASE PLAYER HEALTH]
	queue_free()
