extends Node2D

#player
@onready var player: Player = $Player
#all rooms
var currentRoom = null
var instanceOfRoom = null
var bossRoom = preload("res://scenes/BossRoom/bossFight.tscn")
var enemyRoom1 = preload("res://scenes/EnemyRooms/enemyRoom1.tscn")
var enemyRoom2 = preload("res://scenes/EnemyRooms/enemyRoom2.tscn")
var enemyRoom3 = preload("res://scenes/EnemyRooms/enemyRoom3.tscn")
var shopRoom = preload("res://scenes/ShopRooms/shopRoom1.tscn")
var treasureRoom1 = preload("res://scenes/TreasureRooms/treasureRoom1.tscn")
var treasureRoom2 = preload("res://scenes/TreasureRooms/treasureRoom2.tscn")
var treasureRoom3 = preload("res://scenes/TreasureRooms/treasureRoom3.tscn")
var treasureRoom4 = preload("res://scenes/TreasureRooms/treasureRoom4.tscn")
var roomCount: int = 0

#random number generator
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func choseNextRoom(): 
	#increase room count
	roomCount += 1
	print(roomCount)
	#reset player postion
	player.position = Vector2(0,0)
	if roomCount == 11:
		instanceOfRoom.queue_free()
		currentRoom = bossRoom
		instanceOfRoom = currentRoom.instantiate()
		add_child(instanceOfRoom)
	elif currentRoom == null :
		currentRoom = enemyRoom1
		instanceOfRoom = currentRoom.instantiate()
		add_child(instanceOfRoom)
	else:
		if currentRoom == enemyRoom1 or currentRoom == enemyRoom2 or currentRoom == enemyRoom3:
			instanceOfRoom.queue_free()
			var value: int = random.randi_range(1,4)
			if value == 1:
				currentRoom = treasureRoom1
			elif value == 2:
				currentRoom = treasureRoom2
			elif value == 3:
				currentRoom = treasureRoom3
			elif value == 4:
				currentRoom = treasureRoom4
			instanceOfRoom = currentRoom.instantiate()
			add_child(instanceOfRoom)
		elif currentRoom == treasureRoom1 or currentRoom == treasureRoom2 or currentRoom == treasureRoom3 or currentRoom == treasureRoom4:
			instanceOfRoom.queue_free()
			#[RANDOMLY PICK NEXT ROOM]
			var value: int = random.randi_range(1,4)
			if value == 1:
				currentRoom = shopRoom
			elif value == 2:
				currentRoom = enemyRoom1
			elif value == 3:
				currentRoom = enemyRoom2
			elif value == 4:
				currentRoom = enemyRoom3
			instanceOfRoom = currentRoom.instantiate()
			add_child(instanceOfRoom)
		elif currentRoom == shopRoom:
			instanceOfRoom.queue_free()
			var value: int = random.randi_range(1,3)
			if value == 1:
				currentRoom = enemyRoom1
			elif value == 2:
				currentRoom = enemyRoom2
			elif value == 3:
				currentRoom = enemyRoom3
			instanceOfRoom = currentRoom.instantiate()
			add_child(instanceOfRoom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("nextLevel"):
		choseNextRoom()
