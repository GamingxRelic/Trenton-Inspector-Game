extends Node2D

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		emit_signal("pause_game",value)

var finished := false
var in_menu := false

var player_pos : Vector2
var player

var arrow
var arrow_target : Vector2

var objective_label : Label
var objectves_remaining_label : Label

var minimap

var vol_slider_value := 0

signal select_building
signal next_building

signal set_ui_road_name

signal pause_game

signal return_to_main_menu
