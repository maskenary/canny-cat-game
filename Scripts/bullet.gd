extends Area2D

var bullet_explosion = load("res://Scenes/bullet_explosion.tscn")

var speed := 800
var damage := 1

func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func get_damage() -> int:
	return damage
	
func destroy():
	var particle = bullet_explosion.instantiate()
	particle.position = self.position
	particle.emitting = true
	get_parent().add_child(particle)
	self.queue_free()
	
	
