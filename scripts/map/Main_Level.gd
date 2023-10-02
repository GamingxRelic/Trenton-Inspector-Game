extends Node2D

var selected_building := 1
var highest_id := 7

func _ready():
	GameManager.next_building.connect(next_building)
	select_building()

func select_building():
	GameManager.emit_signal("select_building", selected_building)
	
func next_building():
	if selected_building + 1 <= highest_id:
		selected_building += 1
		print(selected_building)
		select_building()
	else:
		selected_building = -1
		select_building()
		GameManager.arrow.hide()
		print("win!")
