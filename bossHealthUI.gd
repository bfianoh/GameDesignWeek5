extends Control

@onready var health_bar: TextureProgressBar = $TextureProgressBar

func set_health(value):
	health_bar.value = value
