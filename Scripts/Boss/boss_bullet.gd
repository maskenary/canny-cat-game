extends Area2D

var damage := 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func get_damage() -> int:
	return damage
