extends StaticBody2D

var player = null

@onready var ammo: Area2D = $Ammo
@onready var healthPack: Area2D = $HealthPack
@onready var weaponDamageUpgrade: Area2D = $WeaponDamageUpgrade
@onready var weaponSpeedUpgrade: Area2D = $WeaponSpeedUpgrade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getPlayer():
	if player == null:
		print("got player")
		player = get_tree().current_scene.get_node("Player")

func _on_health_pack_button_pressed() -> void:
	getPlayer()
	if player.coin_count >= 15 and player.health < 100:
		player.coin_count -= 15
		healthPack.purchase(player)
		print("purchased health pack")
		print(player.coin_count)


func _on_ammo_button_pressed() -> void:
	getPlayer()
	if player.coin_count >= 10:
		player.coin_count -= 10
		ammo.purchase(player)
		print("purchased ammo")
		print(player.coin_count)

func _on_weapon_damage_button_pressed() -> void:
	getPlayer()
	if player.coin_count >= 20:
		player.coin_count -= 20
		weaponDamageUpgrade.purchase(player)
		print("purchased weapon damage upgrade")
		print(player.coin_count)

func _on_weapon_speed_button_pressed() -> void:
	getPlayer()
	if player.coin_count >= 20 and player.projectile_speed < 600:
		player.coin_count -= 20
		weaponSpeedUpgrade.purchase(player)
		print("purchased weapon speed upgrade")
		print(player.coin_count)
