extends CharacterBody2D
class_name EnemyFly

@export var move_speed: float = 50.0
@export var health: int = 4

var direction: Vector2 = Vector2.RIGHT

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var change_direction_timer: Timer = Timer.new()

func _ready():
	sprite.play("idle")
	add_child(change_direction_timer)
	change_direction_timer.wait_time = 4
	change_direction_timer.one_shot = false
	change_direction_timer.timeout.connect(_on_change_direction_timer_timeout)
	change_direction_timer.start()
	print("EnemyFly initialized. Starting direction:", direction)

func _physics_process(delta):
	velocity = direction * move_speed
	move_and_slide()

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func _on_change_direction_timer_timeout():
	direction *= -1
	print("EnemyFly changed direction:", direction)

func take_damage(amount):
	health -= amount
	#print("EnemyFly took damage:", amount, "Remaining health:", health)
	if health <= 0:
		die()

func die():
	print("EnemyFly dying...")
	sprite.play("death")
	await sprite.animation_finished
	queue_free()
