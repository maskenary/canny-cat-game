extends PathFollow2D

signal spawn_pattern(pattern)
signal enemy_died

var pickup = load("res://Scenes/Enemy/pickup.tscn")
var pattern_spawner = load("res://Scenes/Boss/pattern_spawner.tscn")
var enemy_projectile_formation = load("res://Scenes/Boss/single_spin_formation.tscn")
var progress_speed = 0.075
var hp = 10

@export var attack_timer: Node

func _ready() -> void:
	Autoload.clear_enemies.connect(clear_self)

func _physics_process(delta: float) -> void:
	self.progress_ratio += progress_speed * delta

func attack():
	var pattern = pattern_spawner.instantiate()
	pattern.position = self.position
	emit_signal("spawn_pattern", pattern)
	pattern.shotgun_at_player(enemy_projectile_formation, 150, 3, 0.5, 60, 1, 10)

func _on_area_2d_area_entered(area: Area2D) -> void:
	hp -= area.get_damage()
	area.queue_free()
	if hp <= 0:
		die()
		
func die():
	var p = pickup.instantiate()
	p.position = self.position
	emit_signal("spawn_pattern", p)
	
	emit_signal('enemy_died')
	queue_free()
	
func clear_self():
	queue_free()
	
	
