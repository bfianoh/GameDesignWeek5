extends CharacterBody2D

@export var projectile_scene: PackedScene = preload("res://Scenes/Projectiles/enemy_projectile.tscn")
@export var fire_rate: float = 1.5  # Time in seconds between shots
@export var health: int = 20

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	sprite.play("idle")  # Start in idle state
	start_shooting()

func start_shooting():
	while true:
		await get_tree().create_timer(fire_rate).timeout
		shoot()

func shoot():
	sprite.play("shoot")  # Play shooting animation
	
	var projectile = projectile_scene.instantiate()
	projectile.position = position + Vector2(0, -10)  # Offset to fire from the top
	projectile.direction = Vector2.UP  # Shoots upwards
	projectile.speed = 200
	projectile.damage = 5
	projectile.source = "Enemy"
	
	get_parent().add_child(projectile)
	
	await sprite.animation_finished
	sprite.play("idle")  # Return to idle after shooting

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	sprite.play("death")
	await sprite.animation_finished
	queue_free()
