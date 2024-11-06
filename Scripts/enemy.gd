extends PathFollow2D

signal spawn_pattern(pattern)

var pattern_spawner = load("res://Scenes/Boss/pattern_spawner.tscn")
var single_spin_formation = load("res://Scenes/Boss/single_spin_formation.tscn")
var active = false
var attack_cooldown = 3
var target_position = null
var path_parent = null
var pre_active_speed = 10
var active_speed = 300


func setup(initial_progress, offset: Vector2, path: Node):
	self.progress = initial_progress
	self.h_offset = offset.x
	self.v_offset = offset.y
	path_parent = path

func _process(delta: float) -> void:
	if active:
		self.progress += active_speed
		#await get_tree().create_timer(attack_cooldown).timeout
		#attack()

func _physics_process(delta: float) -> void:
	# Gradually un-offset until reaching starting point, then begin pathing
	if !active:
		"""
		if self.h_offset != 0:
			self.h_offset -= pre_active_speed * sign(self.h_offset)
		if self.v_offset != 0:
			self.v_offset -= pre_active_speed * sign(self.v_offset)
		"""
		# TODO fix the initial spawn -> following path process
		if self.h_offset == 0 and self.v_offset == 0:
			get_parent().remove_child(self)
			path_parent.add_child(self)
			active = true
		

func attack():
	var pattern = pattern_spawner.instantiate()
	pattern.position = self.position
	emit_signal("spawn_pattern", pattern)
	pattern.shotgun_at_player(single_spin_formation, 300, 6, 0.5, 90, 3, 10)
