extends Control

@onready var camera = $Panel/SubViewportContainer/SubViewport/Camera2D
@onready var player_icon = $Panel/SubViewportContainer/SubViewport/PlayerIcon
@onready var objective_marker = $Panel/SubViewportContainer/SubViewport/Objective_Marker

func _ready() -> void:
	GameManager.minimap = self

func _physics_process(_delta) -> void:
	camera.global_position = GameManager.player_pos;
	player_icon.global_position = GameManager.player_pos;
	player_icon.rotation = GameManager.player.rotation + (PI/2)

func set_objective_marker_position(pos : Vector2) -> void:
	objective_marker.global_position = pos-Vector2(50,50)
	
func hide_objective_marker() -> void:
	objective_marker.hide()
