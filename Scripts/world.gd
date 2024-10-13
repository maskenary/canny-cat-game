extends Node

signal update_healthbar()
signal update_dodgebar()
signal update_charges()

var boss = load("res://Scenes/Boss/boss.tscn")
var boss_interface = load("res://Scenes/Boss/boss_interface.tscn")
var boss_instance
var boss_interface_instance
@export var player: Node
@export var boss_spawn: Node

func spawn_boss():
	boss_instance = boss.instantiate()
	boss_instance.position.x = boss_spawn.position.x
	boss_instance.position.y = boss_spawn.position.y
	boss_interface_instance = boss_interface.instantiate()
	
	self.add_child(boss_instance)
	self.add_child(boss_interface_instance)
	
	boss_instance.boss_damage_taken.connect(boss_interface_instance.update_healthbar)
	boss_instance.boss_died.connect(cleanup_boss)
	boss_interface_instance.set_values(boss_instance.boss_name, boss_instance.hp)

func cleanup_boss():
	boss_instance.queue_free()
	boss_interface_instance.queue_free()

func _ready() -> void:
	spawn_boss()
	
func _on_player_bullet_fired(bullet_instance) -> void:
	add_child(bullet_instance)
	
func _process(delta: float) -> void:
	emit_signal("update_dodgebar", player.charge_cd_progress)
	
func _on_player_damage_taken(hp) -> void:
	emit_signal("update_healthbar", hp)
	
func _on_player_charges_changed(charges) -> void:
	emit_signal("update_charges", charges)
