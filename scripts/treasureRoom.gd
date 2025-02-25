extends Node2D

@export var startingY: int

var coin = preload("res://scenes/PickUps/coin.tscn")
var healthPack = preload("res://scenes/PickUps/healthPack.tscn")
var ammo = preload("res://scenes/PickUps/ammo.tscn")

#random number generator
var random = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#generate a random number of coins
	var numCoins = randi_range(2,5)
	print(numCoins)
	var ind = -40
	numCoins = 5
	for i in numCoins:
		var newScene = coin.instantiate();
		add_child(newScene)
		newScene.position = Vector2(ind, startingY)
		ind += 15
	var numHealthPacks = randi_range(0,1)
	numHealthPacks = 1
	print(numHealthPacks)
	for i in numHealthPacks:
		var newScene = healthPack.instantiate();
		add_child(newScene)
		newScene.position = Vector2(ind, startingY) 
		ind += 15
	var numAmmo = randi_range(1,3)
	numAmmo = 3
	print(numAmmo)
	for i in numAmmo:
		var newScene = ammo.instantiate();
		add_child(newScene)
		newScene.position = Vector2(ind, startingY)
		ind += 15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
