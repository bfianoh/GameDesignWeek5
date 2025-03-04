extends CharacterBody2D
class_name FloatBot
signal enemy_defeated
@export var health: int = 4  # health
@export var fire_rate: float = 2.0  # time b/w shots
@export var projectile_scene: PackedScene = preload("res://scenes/EnemyProjectile.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
var is_alive: bool = true

func _ready():
	is_alive = true
	add_to_group("enemy")
	sprite.play("idle")
	start_shooting()

func start_shooting():
	while health > 0 and is_alive:
		await get_tree().create_timer(fire_rate).timeout
		shoot()

func shoot():
	if is_alive:
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
	if health <= 0 and is_alive:
		die()

func die():
	is_alive = false
	sprite.play("death")
	await sprite.animation_finished
	emit_signal("enemy_defeated")
	queue_free()
