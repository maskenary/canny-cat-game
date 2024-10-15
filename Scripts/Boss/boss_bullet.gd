extends Area2D

@export var damage = 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
