extends Area2D

signal boss_damage_taken(hp)
signal boss_died
signal spawn_pattern(pattern)

var death_explosion = load("res://Scenes/big_death_explosion.tscn")
var pickup = load("res://Scenes/pickup.tscn")
var pattern_spawner = load("res://Scenes/Boss/pattern_spawner.tscn")

@export var anim_player: Node
@export var sprite: Node
@export var active_timer: Node
@export var attack_timer: Node
var boss_name = "El Rot"
var hp = 100
var speed = 500

var boss_positions = [] # Set from creator
var boss_positions_index = 0

# These pass into the pattern functions
var single_spin_formation = load("res://Scenes/Boss/single_spin_formation.tscn")
var rotation_formation = load("res://Scenes/Boss/rotation_formation.tscn")

var attack_index = 0

enum States {
	ACTIVE,
	MOVING,
}
var state = States.MOVING;
var target_position = Vector2.ZERO

"""
func update_cooldowns(attack_cooldown, active_duration):
	attack_timer.wait_time = attack_cooldown
	active_timer.wait_time = active_duration
"""

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("destroy") and area.has_method("get_damage"):
		hp -= area.get_damage()
		area.destroy()

	emit_signal("boss_damage_taken", hp)
	if hp <= 0:
		var particle = death_explosion.instantiate()
		particle.position = self.position
		particle.emitting = true
		get_parent().add_child(particle)
		
		emit_signal("boss_died")

func animate_self(animation):
	if anim_player.current_animation != animation:
		anim_player.play(animation)

func set_target_position(x, y):
	target_position = Vector2(x, y)

func _process(delta: float) -> void:
	if state == States.MOVING:
		animate_self("moving")
		sprite.modulate = Color(0.533, 0, 0)
		if position == target_position:
			active_timer.start(0)
			attack_timer.start(0)
			state = States.ACTIVE
			
	elif state == States.ACTIVE:
		sprite.modulate = Color(1, 1, 1)
		animate_self("idle")

		
func _physics_process(delta: float) -> void:
	if state == States.MOVING:
		var move_dir = position.direction_to(target_position)
		move_dir = move_dir.normalized()
		var x_movement = move_dir.x * speed * delta
		var y_movement = move_dir.y * speed * delta
		if abs(target_position.x - position.x) < abs(x_movement):
			position.x = target_position.x
		else:
			position.x += x_movement 
			
		if abs(target_position.y - position.y) < abs(y_movement):
			position.y = target_position.y
		else:
			position.y += y_movement 


func _on_active_timer_timeout() -> void:
	attack_timer.stop()
	if boss_positions_index+1 >= len(boss_positions):
		boss_positions_index = 0
	else:
		boss_positions_index+=1
	var next_position = boss_positions[boss_positions_index]
	set_target_position(next_position.position.x, next_position.position.y)
	state = States.MOVING

func _on_attack_timer_timeout() -> void:
	var pattern = pattern_spawner.instantiate()
	pattern.position = self.position
	emit_signal("spawn_pattern", pattern)
	if attack_index == 0:
		pattern.shoot_at_player(rotation_formation, 100, 1, 0, 5)
	elif attack_index == 1:
		pattern.rain(single_spin_formation, 300, 5, 0.3, true, 10)
	elif attack_index == 2:
		pattern.shoot_at_player(rotation_formation, 400, 10, 0.1, 10)
	elif attack_index == 3:
		pattern.rain(single_spin_formation, 300, 5, 0.3, false, 10)
	elif attack_index == 4:
		pattern.shotgun_at_player(single_spin_formation, 300, 6, 0.5, 90, 3, 10)
	attack_index += 1
	if attack_index > 4:
		attack_index = 0
	
	
