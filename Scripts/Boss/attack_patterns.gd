extends Node2D

var exploding_burst = load("res://Scenes/Boss/exploding_burst.tscn")

func throw_bursts(count):
	for i in range(count):
		var b = exploding_burst.instantiate()
		var player = get_tree().get_nodes_in_group("player")[0]
		b.global_position = self.global_position
		b.set_movement(self.position.direction_to(player.global_position), 100)
		self.add_child(b)
	self.queue_free()
