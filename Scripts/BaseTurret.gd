extends CharacterBody2D
class_name BaseTurret

@export var health: int = 4
@export var fire_rate: float = 2.0
@export var projectile_scene: PackedScene = preload("res://Scenes/EnemyProjectile.tscn")
@export var shoot_direction: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	sprite.play("idle")
	start_shooting()

func start_shooting():
	while health > 0:
		await get_tree().create_timer(fire_rate).timeout
		shoot()

func shoot():
	sprite.play("shoot")

	var projectile = projectile_scene.instantiate()
	projectile.position = position + Vector2(0, 0)
	projectile.direction = shoot_direction
	projectile.speed = 300 
	projectile.damage = 25
	projectile.source = self.name
	get_parent().add_child(projectile)

	await sprite.animation_finished
	sprite.play("idle")

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	sprite.play("death")
	await sprite.animation_finished
	sprite.stop() 
	queue_free()
