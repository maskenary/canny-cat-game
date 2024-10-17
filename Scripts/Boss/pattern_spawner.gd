extends Node2D

@export var lifetime_timer: Node

func shoot_at_player(projectile, speed, count, interval, lifetime):
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	var player = get_tree().get_nodes_in_group("player")[0]
	var direction = self.position.direction_to(player.position)
	for i in range(count):
		var p = projectile.instantiate()
		p.set_movement(direction, speed)
		add_child(p)
		await get_tree().create_timer(interval).timeout

func rain_down(projectile, speed, count, interval, spacing_min, spacing_max, lifetime):
	self.position = Vector2.ZERO
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	
	var x_spawn = 0
	for i in range(count):
		x_spawn += randf_range(spacing_min, spacing_max)
		x_spawn = wrapf(x_spawn, 0, get_viewport().size.x)
		var p = projectile.instantiate()
		p.position = Vector2(x_spawn, 0)
		p.set_movement(Vector2(0, 1), speed)
		add_child(p)
		await get_tree().create_timer(interval).timeout
	
func _on_timer_timeout() -> void:
	self.queue_free()
