extends Node2D

@export var lifetime_timer: Node

func shoot_at_player(projectile, speed, projectile_count, interval, lifetime):
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	var player = get_tree().get_nodes_in_group("player")[0]
	var direction = self.position.direction_to(player.position)
	for i in range(projectile_count):
		var p = projectile.instantiate()
		p.set_movement(direction, speed)
		add_child(p)
		await get_tree().create_timer(interval).timeout

func rain_down(projectile, speed, projectile_count, interval, number, lifetime):
	self.position = Vector2.ZERO
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	
	var spacing = get_viewport().size.x / projectile_count
	for r in range(number):
		var x_spawn = 0 + spacing/2 # Spacing margin
		for c in range(projectile_count):
			var p = projectile.instantiate()
			p.position = Vector2(x_spawn, 0)
			p.set_movement(Vector2(0, 1), speed)
			add_child(p)
			x_spawn += spacing
		await get_tree().create_timer(interval).timeout
		
func shotgun_at_player(projectile, speed, projectile_count, interval, degree_spread, number, lifetime):
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	
	var angle_spread = deg_to_rad(degree_spread)
	var player = get_tree().get_nodes_in_group("player")[0]
	
	for n in range(number):
		var angle_to_player = self.position.angle_to_point(player.position)
		var current_angle = angle_to_player - angle_spread/2
		current_angle += (angle_spread/projectile_count)/2 # Spacing margin
		for c in range(projectile_count):
			var p = projectile.instantiate()
			p.set_movement(Vector2(cos(current_angle), sin(current_angle)), speed)
			add_child(p)
			current_angle += angle_spread / projectile_count
		await get_tree().create_timer(interval).timeout
	
func _on_timer_timeout() -> void:
	self.queue_free()
