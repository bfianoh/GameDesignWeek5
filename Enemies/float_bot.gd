extends CharacterBody2D
class_name FloatBot
signal enemy_defeated
@export var health: int = 4  # health
@export var fire_rate: float = 2.0  # time b/w shots
@export var projectile_scene: PackedScene = preload("res://scenes/EnemyProjectile.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	add_to_group("enemy")
	sprite.play("idle")
	start_shooting()

func start_shooting():
	while health > 0:
		await get_tree().create_timer(fire_rate).timeout
		shoot()

func shoot():
	sprite.play("shoot")
	
	var projectile = projectile_scene.instantiate()
	projectile.position = position + Vector2(10, 0) 
	projectile.direction = Vector2.RIGHT 
	projectile.speed = 300 
	projectile.damage = 25
	projectile.source = "FloatBot"
	get_parent().add_child(projectile)

	await sprite.animation_finished
	sprite.play("idle")

func take_damage(amount):
	health -= amount
	if health <= 0:
		emit_signal("enemy_defeated")
		die()

func die():
	sprite.play("death")
	await sprite.animation_finished
	sprite.stop() 
	queue_free()
