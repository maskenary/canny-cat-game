extends Area2D

var speed := 800
var damage := 1

func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func get_damage() -> int:
	return damage
