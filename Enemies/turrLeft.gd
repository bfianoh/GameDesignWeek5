extends CharacterBody2D
signal enemy_defeated

@export var move_speed = 50.0
@export var health = 30

var direction = Vector2.LEFT

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	add_to_group("enemy")
	sprite.play("active")

func _physics_process(delta):
	velocity = direction * move_speed
	move_and_slide()

	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

func take_damage(amount):
	health -= amount
	if health <= 0:
		emit_signal("enemy_defeated")
		die()

func die():
	sprite.play("death")
	await sprite.animation_finished
	queue_free()
