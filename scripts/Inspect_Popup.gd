extends Control

func set_info(bldg_name : String, history : String, address : String, image : Texture):
	$CanvasLayer/Name.text = bldg_name
	$CanvasLayer/Panel/History_Text.text = history
	$CanvasLayer/Address.text = address
	$CanvasLayer/ScrollContainer/Image.texture = image

func _on_button_pressed():
	exit()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		exit()
		
func exit():
	GameManager.in_menu = false
	GameManager.game.game_paused = false
	queue_free()
