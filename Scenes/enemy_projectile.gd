extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite

var speed: float = 300
var direction: Vector2 = Vector2.RIGHT
var damage: int = 1
var source: String = "Enemy"

func _ready():
	sprite.play("default")
	connect("body_entered", Callable(self, "_on_body_entered"))
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "_on_screen_exited"))

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D):
	if source == "Enemy" and body is Player:
		body.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
