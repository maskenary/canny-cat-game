extends Node2D

@export var lifetime_timer: Node

func shoot_at_player(projectile, speed, projectile_count, interval, lifetime):
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	var player = get_tree().get_nodes_in_group("player")[0]
	var direction = self.position.direction_to(player.position)
	for i in range(projectile_count):
		create_projectile(projectile, direction, speed)
		await get_tree().create_timer(interval).timeout

func rain(projectile, speed, projectile_count, interval, inverse, lifetime):
	var projectile_direction = 1
	self.position = Vector2.ZERO
	if inverse:
		projectile_direction = -1
		self.position = Vector2(0, get_viewport().size.y)
		
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	var viewport_width = get_viewport().size.x
	for c in range(projectile_count):
		var x_spawn = randf_range(0, viewport_width)
		create_projectile(projectile, Vector2(0, projectile_direction), speed, Vector2(x_spawn, 0))
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
			create_projectile(projectile, Vector2(cos(current_angle), sin(current_angle)), speed)
			current_angle += angle_spread / projectile_count
		await get_tree().create_timer(interval).timeout
	
func _on_timer_timeout() -> void:
	self.queue_free()
	
func create_projectile(projectile, direction, speed, pos = Vector2.ZERO):
	var p = projectile.instantiate()
	p.position = pos
	p.set_movement(direction, speed)
	add_child(p)
	
