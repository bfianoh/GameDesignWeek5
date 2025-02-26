extends Control

func _ready():
	#sfx_game_over.play()
	pass

func _on_retry_pressed() -> void:
	#sfx_click.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	queue_free()

func _on_main_menu_pressed() -> void:
	#sfx_click.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
	queue_free()
