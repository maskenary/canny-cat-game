extends Node

signal update_healthbar()
signal update_dodgebar()
signal update_charges()

@export var player: Node

func _on_player_bullet_fired(bullet_instance) -> void:
	add_child(bullet_instance)
	
func _on_player_damage_taken(hp) -> void:
	emit_signal("update_healthbar", hp)
	
func _process(delta: float) -> void:
	emit_signal("update_dodgebar", player.charge_cd_progress)
	
func _on_player_charges_changed(charges) -> void:
	emit_signal("update_charges", player.charges)
