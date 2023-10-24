extends AudioStreamPlayer2D

func _process(_delta) -> void:
	if Input.is_action_just_pressed("next_song"):
		get_parent().play_next_song()
