extends Area2D
class_name Projectile

@onready var sprite: AnimatedSprite2D = $Sprite

var speed = 400
var direction = Vector2.RIGHT
var damage = 1 # Character should pass in damage # as parameter
var source: String = "Player"

func _ready() -> void:
	sprite.play("default")
	rotate_sprite()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func rotate_sprite():
	var angle = direction.angle()
	sprite.rotation = angle

# SIGNALS

func _on_body_entered(body: Node2D) -> void:
	if source == "Player" and body is Player:
		return
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 
