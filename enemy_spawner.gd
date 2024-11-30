extends Node

signal enemy_spawned(enemy)

var enemy = load("res://Scenes/enemy.tscn")
var enemy_count_pattern = [3, 6, 2, 4]
var ecp_index = 0
var spawning_interval = 0.5

@export var enemy_paths: Array[Node]
@export var timer: Node

func start():
	timer.start()

func stop():
	timer.stop()

func _on_timer_timeout() -> void:
	# Choose random path
	var path = enemy_paths[randf_range(0, len(enemy_paths))]
	# Pause spawn timer
	timer.set_paused(true)
	# Spawn random amount of enemies in sequence (or iterate through an array of numbers)
	for i in range(enemy_count_pattern[ecp_index]):
		var e = enemy.instantiate()
		# Tell world to connect signals with enemy
		emit_signal("enemy_spawned", e)
		path.add_child(e)
		await get_tree().create_timer(spawning_interval).timeout
	# Resume spawn timer when everyone is spawned
	timer.set_paused(false)
	ecp_index += 1
