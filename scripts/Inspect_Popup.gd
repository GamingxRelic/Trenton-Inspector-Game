extends Control

func set_info(bldg_name : String, history : String, address : String, img : Texture) -> void:
	$CanvasLayer/Name.text = bldg_name
	$CanvasLayer/Panel/History_Text.text = history
	$CanvasLayer/Address.text = address
	$CanvasLayer/ScrollContainer/Image.texture = img

func _on_button_pressed() -> void:
	exit()

func _process(_delta) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("interact"):
		exit()

func exit() -> void:
	GameManager.in_menu = false
	GameManager.game_paused = false
	if GameManager.finished:
		var win_screen = preload("res://scenes/ui/Win_Screen.tscn").instantiate()
		get_node("/root").call_deferred("add_child", win_screen)
	queue_free()
