extends CharacterBody2D
class_name BigBot

@export var move_speed = 50.0
@export var health = 30

var direction = Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	sprite.play("idle")

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
		die()

func die():
	sprite.play("death")
	await sprite.animation_finished
	queue_free()
