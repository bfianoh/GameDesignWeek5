extends CharacterBody2D
class_name BigBot

@export var move_speed: float = 30.0
@export var health: int = 30
@export var detection_range: float = 50.0
@export var stop_distance: float = 20.0 
@export var push_force: float = 5.0
@export var damage: int = 10

var player: Node2D = null

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready():
	sprite.play("idle")
	find_player()

func _physics_process(delta):
	if player and position.distance_to(player.position) <= detection_range:
		follow_player()
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

	move_and_slide()

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func find_player():
	var player_node = get_tree().get_nodes_in_group("player")
	if player_node.size() > 0:
		player = player_node[0]

func follow_player():
	var direction = (player.position - position).normalized()
	var distance = position.distance_to(player.position)
	
	if distance > stop_distance:
		velocity = direction * move_speed
		sprite.play("run")
	else:
		velocity = direction * move_speed * 0.3
		sprite.play("idle")

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"): 
		body.take_damage(damage)
		
		var push_back = (position - body.position).normalized() * push_force
		position += push_back

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# stopping all movement and actions for player & enemy
	set_physics_process(false)
	player = null
	velocity = Vector2.ZERO
	sprite.play("death")

	await sprite.animation_finished 
	sprite.stop() 
	queue_free()
