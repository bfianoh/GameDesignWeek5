extends Control

var howToPlay = preload("res://scenes/Menus/how_to_play.tscn")

func _ready() -> void:
	#sfx_bgm.play()
	pass

func _on_start_pressed() -> void:
	#sfx_click.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_how_to_play_pressed() -> void:
	#sfx_click.play()
	var howToPlay_isntance = howToPlay.instantiate()
	get_tree().root.add_child(howToPlay_isntance)

func _on_quit_pressed() -> void:
	#sfx_click.play()
	get_tree().quit()
