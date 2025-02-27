extends CharacterBody2D

var win_screen = preload("res://scenes/Menus/win_screen.tscn")

@export var health: int = 200
@export var speed: float = 50.0
@export var fire_rate: float = 2.0
@export var projectile_scene: PackedScene = preload("res://Boss/BossProjectile.tscn")  # Ensure correct path

var ui_health_bar = null
var player = null
var shoot_timer = null

func _ready():
	player = get_tree().get_first_node_in_group("player")  
	start_shooting_timer()
	update_health_ui()

func _physics_process(delta):
	if player:
		move_towards_player(delta)

func move_towards_player(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func start_shooting_timer():
	if shoot_timer: return  # Prevent multiple timers from being added
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.autostart = true
	shoot_timer.one_shot = false
	shoot_timer.connect("timeout", Callable(self, "_shoot_projectile"))
	add_child(shoot_timer)

func _shoot_projectile():
	if player and projectile_scene:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		if projectile.has_method("set_direction"):
			projectile.set_direction((player.global_position - global_position).normalized())  
		get_tree().current_scene.add_child(projectile)  # Ensures projectile is added to the main scene

func take_damage(amount):
	health -= amount
	update_health_ui()
	if health <= 0:
		die()
		
func update_health_ui():
	if ui_health_bar:
		ui_health_bar.set_health(health)
		
func die():
	queue_free()
	get_tree().paused = true
	var win_screen_instance = win_screen.instantiate()
	get_tree().root.add_child(win_screen_instance)
