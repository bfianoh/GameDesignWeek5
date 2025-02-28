extends CharacterBody2D

var win_screen = preload("res://scenes/Menus/win_screen.tscn")

@export var maxHealth: int = 200
@export var speed: float = 50.0
@export var fire_rate: float = 2.0
@export var projectile_scene: PackedScene = preload("res://Boss/BossProjectile.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health_bar: ProgressBar = $HealthBar

var ui_health_bar = null
var player = null
var shoot_timer = null
var health: int = maxHealth

func _ready():
	player = get_tree().get_first_node_in_group("player")  
	start_shooting_timer()
	health = maxHealth
	if health_bar:
		health_bar.visible = true
	update_health_ui()
	add_to_group("boss")

func _physics_process(delta):
	if player:
		move_towards_player(delta)
		avoid_collisions()
	if health_bar:
		health_bar.global_position = global_position + Vector2(-10, -30)

func move_towards_player(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		if direction.length() > 0:
			sprite.play("run")

		move_and_slide()

func avoid_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			var push_direction = (global_position - collision.get_collider().global_position).normalized()
			global_position += push_direction * 3

func start_shooting_timer():
	if shoot_timer: return
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.autostart = true
	shoot_timer.one_shot = false
	shoot_timer.connect("timeout", Callable(self, "_shoot_projectile"))
	add_child(shoot_timer)

func _shoot_projectile():
	if player and projectile_scene:
		sprite.play("shoot")  # this does not work lol cuz boss always moving
		
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		if projectile.has_method("set_direction"):
			projectile.set_direction((player.global_position - global_position).normalized())  
		get_tree().current_scene.add_child(projectile)
		
		await sprite.animation_finished
		sprite.play("run")

func take_damage(amount):
	health -= amount
	update_health_ui()
	if health <= 0:
		die()

func update_health_ui():
	if health_bar:
		health_bar.value = health
		
func die():
	queue_free()
	get_tree().paused = true
	var win_screen_instance = win_screen.instantiate()
	get_tree().root.add_child(win_screen_instance)
