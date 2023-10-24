extends Area2D

@export var road_name : String

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		GameManager.emit_signal("set_ui_road_name", road_name)
