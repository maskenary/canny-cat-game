extends PathFollow2D

signal spawn_pattern(pattern)
signal enemy_died

var pattern_spawner = load("res://Scenes/Boss/pattern_spawner.tscn")
var single_spin_formation = load("res://Scenes/Boss/single_spin_formation.tscn")
var active = false
var target_position = null
var path_parent = null
var pre_active_speed = 300
var active_speed = 0.05
var hp = 10

@export var attack_timer: Node

func _ready() -> void:
	Events.clear_enemies.connect(clear_self)
	self.modulate = Color(0, 0, 1, 0.475)

func setup(initial_progress, offset: Vector2):
	self.progress_ratio = initial_progress
	self.h_offset = offset.x
	self.v_offset = offset.y
	
func _physics_process(delta: float) -> void:
	# Gradually un-offset until reaching starting point, then begin pathing
	if !active:
		if self.h_offset != 0:
			self.h_offset -= pre_active_speed * sign(self.h_offset) * delta
			if abs(self.h_offset) < pre_active_speed * delta:
				self.h_offset = 0
				
		if self.v_offset != 0:
			self.v_offset -= pre_active_speed * sign(self.v_offset) * delta
			if abs(self.v_offset) < pre_active_speed * delta:
				self.v_offset = 0
				
		if self.h_offset == 0 and self.v_offset == 0:
			self.modulate = Color(1, 1, 1)
			attack_timer.start()
			active = true
			
	elif active:
		self.progress_ratio += active_speed * delta

func attack():
	var pattern = pattern_spawner.instantiate()
	pattern.position = self.position
	emit_signal("spawn_pattern", pattern)
	pattern.shotgun_at_player(single_spin_formation, 300, 3, 0.5, 60, 2, 10)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if active:
		hp -= area.get_damage()
		area.queue_free()
		if hp <= 0:
			emit_signal('enemy_died')
			queue_free()

func clear_self():
	queue_free()
	
	
