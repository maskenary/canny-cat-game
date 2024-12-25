extends Node

signal enemy_spawned(enemy)

const max_enemy_count = 3
var enemy_count = 0
var enemy = load("res://Scenes/Enemy/enemy.tscn")
var ecp_index = 0
var spawning_interval = 0.3
var max_enemy_spawns = 4

@export var enemy_paths: Array[Node]
@export var timer: Node

func start():
	spawn()
	timer.start()

func stop():
	timer.stop()

func spawn():
	# Choose random path
	var path = enemy_paths[randf_range(0, len(enemy_paths))]
	# Pause spawn timer
	timer.set_paused(true)
	# Spawn random amount of enemies in sequence
	for i in range(randf_range(0, max_enemy_spawns)):
		var e = enemy.instantiate()
		# Tell world to connect signals with enemy
		emit_signal("enemy_spawned", e)
		path.add_child(e)
		await get_tree().create_timer(spawning_interval).timeout
		enemy_count += 1
	# Resume spawn timer when everyone is spawned
	timer.set_paused(false)

func _on_timer_timeout() -> void:
	if enemy_count < max_enemy_count:
		spawn()

func enemy_died():
	enemy_count -= 1
