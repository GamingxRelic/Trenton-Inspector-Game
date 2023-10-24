extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	GameManager.finished = false
	anim_player.play("enter_fade_in_out")

func _process(_delta) -> void:
	if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("brake"):
		anim_player.play("screen_fade_out")
		
func load_level() -> void:
	var level = preload("res://scenes/map/Main_Level.tscn").instantiate()
	get_parent().add_child(level)
	
