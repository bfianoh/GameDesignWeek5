extends Area2D
class_name BossProjectile  # Changed from Projectile to BossProjectile

@onready var sprite: AnimatedSprite2D = $Sprite
@export var speed: float = 200.0
var direction = Vector2.ZERO
var damage = 1
var source: String = "Boss"  # Explicitly set source

func _ready() -> void:
	sprite.play("default")
	rotate_sprite()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta  # Moves the projectile forward

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()

func rotate_sprite():
	if direction != Vector2.ZERO:
		rotation = direction.angle()

# Handle Collision
func _on_body_entered(body: Node2D) -> void:
	if body.name == source:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 
