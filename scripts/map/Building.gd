@tool

extends Node2D

@export var res : Building

var selected := false
@export var id : int

@onready var sprite : Sprite2D = $Sprite2D
var player_in_range := false

func _ready():
	sprite.texture = res.building_sprite
	GameManager.select_building.connect(check_selection)
	
func _process(_delta):
	if selected and !player_in_range:
		material = preload("res://assets/shaders/yellow_outline.tres").duplicate()
	elif !selected and !player_in_range:
		material = null
	
	if player_in_range and Input.is_action_just_pressed("interact") and !GameManager.in_menu:
		if selected:
			selected = false
			GameManager.next_building.emit()
			
		var popup = preload("res://scenes/inspection_popup/Inspect_Popup.tscn").instantiate()
		popup.set_info(res.building_name, res.history, res.address, res.image)
		get_node("/root").call_deferred("add_child", popup)
		GameManager.game.game_paused = true
		GameManager.in_menu = true
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		material = preload("res://assets/shaders/outline.tres").duplicate()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		material = null
		
func check_selection(bldg_id):
	if bldg_id == id:
		GameManager.arrow_target = global_position
		selected = true
	else:
		selected = false
