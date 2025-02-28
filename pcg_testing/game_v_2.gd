extends Node2D

@onready var player: CharacterBody2D = $Player

var enemyRooms = [
	preload("res://scenes/EnemyRooms/enemyRoom1.tscn"),
	preload("res://scenes/EnemyRooms/enemyRoom4.tscn"),
	preload("res://scenes/EnemyRooms/enemyRoom5.tscn"),
	preload("res://scenes/EnemyRooms/enemyRoom6.tscn")
]
var hallway_straight = preload("res://Hallways/hallway_straight.tscn")

var used_positions = {}
var door_links = {}

var rng = RandomNumberGenerator.new()
var room_size = Vector2(320, 320)

func _ready():
	generate_dungeon()

func generate_dungeon():
	used_positions.clear()
	door_links.clear()

	var start_pos = Vector2.ZERO
	var first_room = spawn_enemy_room(start_pos)

	var path = generate_room_path(start_pos, 4)

	# Generate rooms connected via hallways
	for i in range(path.size() - 1):
		var room_pos = path[i]
		var next_room_pos = path[i + 1]

		# Spawn hallway in between rooms
		var hallway_pos = (room_pos + next_room_pos) / 2
		var hallway = spawn_hallway(hallway_pos)

		# Spawn the next room
		var next_room = spawn_enemy_room(next_room_pos)

		# Connect hallway doors to rooms
		link_doors(hallway, next_room)

	# Set player start position
	player.position = start_pos * room_size

func generate_room_path(start_pos, length):
	var path = [start_pos]
	var current_pos = start_pos

	for _i in range(length):
		var next_pos = get_valid_position(current_pos)
		path.append(next_pos)
		current_pos = next_pos
	
	return path

func get_valid_position(current_pos):
	var directions = [Vector2(0, 1), Vector2(0, -1)]
	directions.shuffle()

	for dir in directions:
		var new_pos = current_pos + dir
		if not used_positions.has(new_pos):
			used_positions[new_pos] = true
			return new_pos
	
	return current_pos

func spawn_enemy_room(grid_pos):
	var room_scene = enemyRooms[rng.randi_range(0, enemyRooms.size() - 1)]
	var room_instance = room_scene.instantiate()
	add_child(room_instance)
	room_instance.position = grid_pos * room_size
	
	var doors = {}
	for marker in room_instance.get_children():
		if marker is Marker2D:
			doors[marker.name] = marker
	door_links[room_instance] = doors
	
	print("Spawned Enemy Room at:", grid_pos)
	return room_instance

func spawn_hallway(grid_pos):
	var hallway_instance = hallway_straight.instantiate()
	add_child(hallway_instance)
	hallway_instance.position = grid_pos * room_size

	var doors = {}
	for marker in hallway_instance.get_children():
		if marker is Marker2D:
			doors[marker.name] = marker
	door_links[hallway_instance] = doors

	print("Spawned Hallway at:", grid_pos)
	return hallway_instance

func link_doors(hallway, room):
	if "Door_Top" in door_links[hallway] and "Door_Bottom" in door_links[room]:
		var hallway_top = door_links[hallway]["Door_Top"]
		var room_bottom = door_links[room]["Door_Bottom"]

		room.position = hallway.position + Vector2(0, room_size.y)

		print("Linked Hallway (Top) to Room (Bottom)")

func _on_door_interacted(door_name, room_instance):
	if door_name == "Door_Top" or door_name == "Door_Bottom":
		var hallway = spawn_hallway(room_instance.position + Vector2(0, room_size.y))
		var next_room = spawn_enemy_room(room_instance.position + Vector2(0, room_size.y * 2))
		link_doors(hallway, next_room)
		player.position = hallway.position
