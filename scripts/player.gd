extends CharacterBody2D
class_name Player

var player_projectile = preload("res://scenes/player_projectile.tscn")
var death_screen = preload("res://scenes/Menus/death_screen.tscn")

@export var move_speed = 150.0
@export var projectile_speed = 400
@export var damage = 20

@export_category("Health and Damage")
@export var health_ui_label_node: Label = null
@export var maxHealth: int = 100

var move_dir: Vector2
var facing_dir: Vector2 = Vector2.RIGHT
var health: int = maxHealth
var is_shooting: bool = false
var is_alive: bool = true
var coin_count: int = 0
var ammo: int = 50

func _ready():
	is_alive = true
	health = maxHealth

func _physics_process(delta: float) -> void:
	if is_alive:
		# Movement
		move_dir.x = Input.get_axis("left", "right")
		move_dir.y = Input.get_axis("up", "down")
		move_dir = move_dir.normalized()
		
		if move_dir != Vector2.ZERO:
			facing_dir = move_dir
		
		# flip
		if move_dir.x > 0: %Sprite.flip_h = false
		elif move_dir.x < 0: %Sprite.flip_h = true
		
		# Apply movement
		velocity = move_dir * move_speed
		move_and_slide()

		# Prevent sticking by applying a push force if colliding with the boss
		handle_collisions()

		# Play animations
		if is_shooting:
			%Sprite.play("shoot")
		elif move_dir:
			%Sprite.play("run")
		else:
			%Sprite.play("idle")
		
		# Shoot
		if Input.is_action_just_pressed("shoot"):
			if !is_shooting:
				shoot()

func handle_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("boss"):
			var push_direction = (global_position - collision.get_collider().global_position).normalized()
			global_position += push_direction * 5  # Adjust push strength as needed

func shoot():
	if ammo == 0:
		return
	
	ammo -= 1
	is_shooting = true
	%Sprite.play("shoot")
	
	var projectile = player_projectile.instantiate()
	projectile.position = position + Vector2(0,6)
	projectile.direction = facing_dir
	projectile.speed = projectile_speed
	projectile.damage = damage
	projectile.source = "Player"
	get_parent().add_child(projectile)
	
	await %Sprite.animation_finished
	is_shooting = false

func take_damage(value: int):
	health -= value
	if health <= 0:
		die()

func die():
	is_alive = false
	%Sprite.play("death")
	await %Sprite.animation_finished
	get_tree().paused = true
	var death_screen_instance = death_screen.instantiate()
	get_tree().root.add_child(death_screen_instance)
