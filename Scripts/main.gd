extends Node

@onready var interface = $Interface
@onready var player = $Player

func _on_player_bullet_fired(bullet_instance) -> void:
	add_child(bullet_instance)
	
func _on_player_damage_taken(hp) -> void:
	interface.update_healthbar(hp)
	
func _process(delta: float) -> void:
	interface.update_dodgebar(player.charge_cd_progress)
	
func _on_player_charges_changed(charges) -> void:
	interface.update_charges(charges)
