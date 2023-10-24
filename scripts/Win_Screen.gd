extends CanvasLayer

func _ready() -> void:
	GameManager.game_paused = true
	GameManager.in_menu = true

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("interact"):
		GameManager.game_paused = false
		GameManager.in_menu = false
		queue_free()

func _on_exit_button_pressed():
	GameManager.game_paused = false
	GameManager.in_menu = false
	GameManager.return_to_main_menu.emit()
	queue_free()

func _on_resume_button_pressed():
	GameManager.game_paused = false
	GameManager.in_menu = false
	queue_free()
