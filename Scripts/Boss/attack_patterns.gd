extends Node2D

signal spawn_attack(instance)
var exploding_burst = load("res://Scenes/Boss/exploding_burst.tscn")


func throw_bursts(count):
	print("running throw bursts")
	for i in range(count):
		var b = exploding_burst.instantiate()
		var player = get_tree().get_nodes_in_group("player")[0]
		b.position = self.position
		b.set_movement(self.position.direction_to(player.position), 100)
		emit_signal("spawn_attack", b)
		await get_tree().create_timer(2).timeout
	self.queue_free()
