extends CanvasLayer

@onready var vol_slider = $Volume_Slider

func _ready() -> void:
	vol_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("interact"):
		GameManager.game_paused = false
		GameManager.in_menu = false
		queue_free()

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol_slider.value)
	GameManager.vol_slider_value = vol_slider.value
		
func _on_exit_button_pressed():
	GameManager.game_paused = false
	GameManager.in_menu = false
	GameManager.return_to_main_menu.emit()

func _on_resume_button_pressed():
	GameManager.game_paused = false
	GameManager.in_menu = false
	queue_free()



