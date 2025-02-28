extends Node2D

@onready var player: Player = $Player

# all rooms
var currentRoom = null
var instanceOfRoom = null
var starterRoom = preload("res://Scenes/starterRoom.tscn")
var bossRoom = preload("res://scenes/BossRoom/bossFight.tscn")
var enemyRoom1 = preload("res://scenes/EnemyRooms/enemyRoom1.tscn")
var enemyRoom2 = preload("res://scenes/EnemyRooms/enemyRoom2.tscn")
var enemyRoom3 = preload("res://scenes/EnemyRooms/enemyRoom3.tscn")
var shopRoom = preload("res://scenes/ShopRooms/shopRoom1.tscn")
var treasureRoom1 = preload("res://scenes/TreasureRooms/treasureRoom1.tscn")
var treasureRoom2 = preload("res://scenes/TreasureRooms/treasureRoom2.tscn")
var treasureRoom3 = preload("res://scenes/TreasureRooms/treasureRoom3.tscn")
var treasureRoom4 = preload("res://scenes/TreasureRooms/treasureRoom4.tscn")
var death_screen = preload("res://scenes/Menus/death_screen.tscn")
var roomCount: int = 0
var paused: bool = false

# Enemy tracking logic
var enemy_count: int = 0
var enemies_eliminated: int = 0

var random = RandomNumberGenerator.new()

func _ready() -> void:
	currentRoom = starterRoom
	instanceOfRoom = currentRoom.instantiate()
	add_child(instanceOfRoom)
	if player:
		player.health_bar.visible = true
		player.update_health_ui()
	player.position = Vector2(0, 0)

	# Check for enemies when room starts based on enemy group
	check_enemy_status()

func check_enemy_status():
	# skip enemy counting in shop or treasure rooms
	if currentRoom in [shopRoom, treasureRoom1, treasureRoom2, treasureRoom3, treasureRoom4]:
		enemy_count = 0
		enemies_eliminated = 0
		print("This is a non-combat room. You can proceed freely.")
		return
	
	enemy_count = 0
	enemies_eliminated = 0
	
	# Get all enemies in the "enemy" group
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		enemy_count += 1
		if not enemy.is_connected("enemy_defeated", Callable(self, "_on_enemy_defeated")):
			enemy.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))

	print("Total enemies in this room:", enemy_count)

func _on_enemy_defeated():
	enemies_eliminated += 1
	print("Enemy defeated! Total defeated:", enemies_eliminated, "/", enemy_count)
	
	if enemies_eliminated >= enemy_count:
		print("All enemies eliminated! You can now proceed.")

func choseNextRoom():
	if enemy_count > 0 and enemies_eliminated < enemy_count:
		print("Defeat all enemies before proceeding!")
		return
	
	roomCount += 1
	print("Moving to room:", roomCount)
	player.position = Vector2(0, 0)

	instanceOfRoom.queue_free()
	
	# Check if it's time for the boss room
	if roomCount == 11:
		currentRoom = bossRoom
	else:
		if currentRoom == starterRoom:
			currentRoom = enemyRoom1
		elif currentRoom in [enemyRoom1, enemyRoom2, enemyRoom3]:
			var value: int = random.randi_range(1, 4)
			match value:
				1: currentRoom = treasureRoom1
				2: currentRoom = treasureRoom2
				3: currentRoom = treasureRoom3
				4: currentRoom = treasureRoom4
		elif currentRoom in [treasureRoom1, treasureRoom2, treasureRoom3, treasureRoom4]:
			var value: int = random.randi_range(1, 4)
			match value:
				1: currentRoom = shopRoom
				2: currentRoom = enemyRoom1
				3: currentRoom = enemyRoom2
				4: currentRoom = enemyRoom3
		elif currentRoom == shopRoom:
			var value: int = random.randi_range(1, 3)
			match value:
				1: currentRoom = enemyRoom1
				2: currentRoom = enemyRoom2
				3: currentRoom = enemyRoom3

	instanceOfRoom = currentRoom.instantiate()
	add_child(instanceOfRoom)

	# re-check for enemies in the new room
	check_enemy_status()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("nextLevel"):
		choseNextRoom()
	if Input.is_action_just_pressed("pause"):
		# Instantiate Death Screen (Add Later)
		var death_screen_instance = death_screen.instantiate()
		get_tree().root.add_child(death_screen_instance)
