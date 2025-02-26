extends Control

func _ready():
	#sfx_win.play()
	pass

func _on_retry_pressed() -> void:
	#sfx_click.play()
	queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	

func _on_main_menu_pressed() -> void:
	#sfx_click.play()
	queue_free()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
