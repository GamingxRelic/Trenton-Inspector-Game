extends Node2D

@onready var music := $Music
var songs := {
	0: preload("res://assets/audio/music/2019-01-10_-_Land_of_8_Bits_-_Stephen_Bennett_-_FesliyanStudios.com.mp3"),
	1: preload("res://assets/audio/music/Beat_Mekanik_-_The_Urban_Gentry.mp3"),
	2: preload("res://assets/audio/music/2020-06-18_-_8_Bit_Retro_Funk_-_www.FesliyanStudios.com_David_Renda.mp3")
}

var curr_song := 0

# Testing music change
#func _process(delta): 
#	if Input.is_action_just_pressed("interact"):
#		play_next_song()

func _ready() -> void:
	GameManager.connect("pause_game", pause_game)
	GameManager.connect("return_to_main_menu", _on_return_to_main_menu)
	GameManager.finished = false
	music.stream = songs[curr_song]
	music.play()
	
func pause_game(value : bool) -> void:
	get_tree().paused = value
	
func _on_return_to_main_menu():
	var main_menu = preload("res://scenes/menus/MainMenu.tscn").instantiate()
	add_child(main_menu)
	get_node("Main_Level").queue_free()

func _on_music_finished():
	play_next_song()
	
func play_next_song():
	curr_song = curr_song + 1 if curr_song < 2 else 0
	music.stream = songs[curr_song]
	music.play()
