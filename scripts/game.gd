extends Node2D

@onready var player: Player = $Player

# All rooms
var currentRoom = null
var instanceOfRoom = null
var starterRoom = preload("res://scenes/starterRoom.tscn")
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

var enemy_count: int = 0
var enemies_eliminated: int = 0
var enemy_spawn_timer: Timer

var enemy_types = [
	preload("res://Enemies/BigBot.tscn"),
	preload("res://Enemies/FloatBot.tscn"),
	preload("res://Enemies/enemy_fly.tscn"),
	preload("res://Enemies/TurrUp.tscn"),
	preload("res://Enemies/TurrLeft.tscn"),
	preload("res://Enemies/turr_down.tscn")
]

var random = RandomNumberGenerator.new()

func _ready() -> void:
	currentRoom = starterRoom
	instanceOfRoom = currentRoom.instantiate()
	add_child(instanceOfRoom)
	enemy_spawn_timer = Timer.new()
	enemy_spawn_timer.wait_time = 2.0  # Spawns every 3 seconds
	enemy_spawn_timer.autostart = false
	enemy_spawn_timer.one_shot = false
	enemy_spawn_timer.connect("timeout", Callable(self, "_spawn_boss_room_enemy"))
	add_child(enemy_spawn_timer)

	if player:
		player.health_bar.visible = true
		player.update_health_ui()
	player.position = Vector2(0, 0)

	check_enemy_status()

func check_enemy_status():
	if currentRoom in [shopRoom, treasureRoom1, treasureRoom2, treasureRoom3, treasureRoom4]:
		enemy_count = 0
		enemies_eliminated = 0
		print("This is a non-combat room. You can proceed freely.")
		return
	
	enemy_count = 0
	enemies_eliminated = 0
	
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
	
	if roomCount == 10:
		currentRoom = bossRoom
		start_boss_room_spawning()
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
	if currentRoom not in [shopRoom, treasureRoom1, treasureRoom2, treasureRoom3, treasureRoom4]:
		spawn_enemies(instanceOfRoom)


	check_enemy_status()

func spawn_enemies(room_instance):
	var spawn_points = []
	for child in room_instance.get_children():
		if child is Marker2D and child.name.begins_with("EnemySpawnPoint"):
			spawn_points.append(child)

	if spawn_points.is_empty():
		print("No spawn points found in room:", room_instance.name)
		return

	var num_enemies = random.randi_range(1, spawn_points.size())

	for i in range(num_enemies):
		var enemy_scene = enemy_types[random.randi_range(0, enemy_types.size() - 1)]
		var enemy_instance = enemy_scene.instantiate()

		var spawn_point = spawn_points.pop_at(random.randi_range(0, spawn_points.size() - 1))
		enemy_instance.position = spawn_point.position

		room_instance.add_child(enemy_instance)

		enemy_instance.connect("enemy_defeated", Callable(self, "_on_enemy_defeated"))

	print("Spawned", num_enemies, "enemies in", room_instance.name)

func start_boss_room_spawning():
	print("Boss room started! Enemies will spawn every _ (1) seconds.")
	enemy_spawn_timer.start()

func _spawn_boss_room_enemy():
	if currentRoom != bossRoom:
		enemy_spawn_timer.stop()
		return

	var enemy_scene = enemy_types[random.randi_range(0, enemy_types.size() - 1)]
	var enemy_instance = enemy_scene.instantiate()

	var valid_position = false
	var spawn_position = Vector2.ZERO

	while not valid_position:
		spawn_position = Vector2(
			random.randi_range(-300, 300),
			random.randi_range(-300, 300)
		)
		if spawn_position.distance_to(player.position) > 100:
			valid_position = true

	enemy_instance.position = spawn_position
	instanceOfRoom.add_child(enemy_instance)

	print("Spawned a random enemy at", spawn_position)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("nextLevel"):
		choseNextRoom()
	if Input.is_action_just_pressed("pause"):
		var death_screen_instance = death_screen.instantiate()
		get_tree().root.add_child(death_screen_instance)
