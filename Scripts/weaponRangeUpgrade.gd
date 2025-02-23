extends Area2D

#when player touches weapon upgrade make it disappear and increase player weapon range
func _on_body_entered(body: Node2D) -> void:
	purchase(body)

func purchase(body):
	#[INCREASE PLAYER WEAPON RANGE]
	queue_free()
