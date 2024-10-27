extends PathFollow2D

signal spawn_pattern(pattern)

var pattern_spawner = load("res://Scenes/Boss/pattern_spawner.tscn")
var active = false

func _ready() -> void:
	pass

"""
func attack():
	var pattern = pattern_spawner.instantiate()
	pattern.position = self.position
	emit_signal("spawn_pattern", pattern)
	pattern.shotgun_at_player(single_spin_formation, 300, 6, 0.5, 90, 3, 10)
"""
