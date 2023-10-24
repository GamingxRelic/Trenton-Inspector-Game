extends Node2D

var selected_building := 1
var highest_id := 8 # 8 is max

func _ready() -> void:
	GameManager.next_building.connect(next_building)
	GameManager.objectves_remaining_label.text = "" + str(selected_building-1) + "/" +str(highest_id-1) + " buildings"
	select_building()

func select_building() -> void:
	GameManager.emit_signal("select_building", selected_building)
	
func next_building() -> void:
	if selected_building + 1 <= highest_id:
		selected_building += 1
		GameManager.objectves_remaining_label.text = "" + str(selected_building-1) + "/" +str(highest_id-1) + " buildings"
		select_building()
	else:
		GameManager.finished = true
		selected_building = -1
		select_building()
		GameManager.arrow.hide()
		GameManager.minimap.hide_objective_marker()
		GameManager.objective_label.text = "All buildings explored! Thanks for playing"

func _process(_delta):
	if Input.is_action_just_pressed("pause") and !GameManager.in_menu:
		GameManager.in_menu = true
		GameManager.game_paused = true
		
		var pause_menu = preload("res://scenes/menus/PauseMenu.tscn").instantiate()
		add_child(pause_menu)
