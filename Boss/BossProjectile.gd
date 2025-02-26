extends Area2D

@export var speed: float = 200.0
var direction = Vector2.ZERO

func _ready():
	connect("body_entered", Callable(self, "_on_hit"))

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func set_direction(dir: Vector2):
	direction = dir.normalized()

func _on_hit(body):
	if body.is_in_group("player"):
		body.take_damage(10)  # Assuming player has `take_damage()`
	queue_free()  # Destroy projectile on impact
