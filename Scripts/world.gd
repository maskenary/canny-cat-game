extends Node

signal update_healthbar()
signal update_dodgebar()
signal update_charges()
signal update_score

var boss = load("res://Scenes/Boss/boss.tscn")
var boss_interface = load("res://Scenes/Boss/boss_interface.tscn")
var boss_instance
var boss_interface_instance
var enemies_left = 1

@onready var stored_background_material = background.material
@export var player: Node
@export var boss_spawn: Node
@export var boss_positions: Array[Node]
@export var background: Node
@export var enemy_spawner: Node

func _ready() -> void:
	enemy_spawner.start()

func spawn_boss():
	boss_instance = boss.instantiate()
	boss_instance.position.x = boss_spawn.position.x
	boss_instance.position.y = boss_spawn.position.y
	boss_interface_instance = boss_interface.instantiate()
	
	self.add_child(boss_instance)
	self.add_child(boss_interface_instance)
	
	boss_instance.boss_damage_taken.connect(boss_interface_instance.update_healthbar)
	boss_instance.boss_died.connect(cleanup_boss)
	boss_instance.spawn_pattern.connect(spawn_pattern)
	boss_interface_instance.set_values(boss_instance.boss_name, boss_instance.hp)
	
	boss_instance.set_target_position(boss_positions[0].position.x, boss_positions[0].position.y)
	boss_instance.boss_positions = boss_positions

func spawn_pattern(p):
	self.add_child(p)
	
func cleanup_boss():
	boss_instance.queue_free()
	boss_interface_instance.queue_free()
	Autoload.emit_signal("clear_enemies")
	
	# Continue the game
	enemy_spawner.start()
	background.material = stored_background_material

func _on_player_bullet_fired(bullet_instance) -> void:
	add_child(bullet_instance)
	
func _process(delta: float) -> void:
	emit_signal("update_dodgebar", player.charge_cd_progress)

func _on_player_damage_taken(hp) -> void:
	emit_signal("update_healthbar", hp)
	
func _on_player_charges_changed(charges) -> void:
	emit_signal("update_charges", charges)
	
func enemy_died():
	enemies_left -= 1
	print(enemies_left)
	if enemies_left <= 0:
		Autoload.emit_signal("clear_enemies")
		enemy_spawner.stop()
		spawn_boss()
		background.material = null

# Link signals of enemy
func _on_enemy_spawner_enemy_spawned(enemy: Variant) -> void:
	enemy.spawn_pattern.connect(spawn_pattern)
	enemy.enemy_died.connect(enemy_died)
