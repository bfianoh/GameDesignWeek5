extends CharacterBody2D
class_name Player

var player_projectile = preload("res://scenes/player_projectile.tscn")

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
var ammo: int = 20

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
		
		if move_dir:
			velocity = move_dir * move_speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, move_speed)
		move_and_slide()
		
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
	# health_ui_label_node.text = str(health) #EDIT LATER
	if health <= 0:
		die()

func die():
	is_alive = false
	%Sprite.play("death")
	await %Sprite.animation_finished
	get_tree().paused = true
	# Instantiate Death Screen (Add Later)
	
func shop():
	pass
