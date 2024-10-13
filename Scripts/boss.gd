extends Area2D

signal boss_damage_taken(hp)
signal boss_died

var boss_name = "Uncatty, The Neuron Rotter"
var hp = 100

func _on_area_entered(area: Area2D) -> void:
	hp -= 1
	emit_signal("boss_damage_taken", hp)
	area.queue_free()
		
	if hp <= 0:
		emit_signal("boss_died")
