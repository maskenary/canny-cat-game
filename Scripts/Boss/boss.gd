extends Area2D

signal boss_damage_taken(hp)
signal boss_died
signal spawn_pattern(pattern)

var attack_patterns = load("res://Scenes/Boss/attack_patterns.tscn")

@export var anim_player: Node
@export var sprite: Node
@export var active_timer: Node
@export var attack_timer: Node
var boss_name = "Uncatty, The Rotter of Neurons"
var hp = 300
var speed = 800

var boss_positions = [] # Set from creator
var boss_positions_index = 0
var boss_attacks = ["throw_bursts"] # Set according to functions in "AttackPatterns"

enum States {
	ACTIVE,
	MOVING,
}
var state = States.MOVING;
var target_position = Vector2.ZERO

func update_cooldowns(attack_cooldown, active_duration):
	attack_timer.wait_time = attack_cooldown
	active_timer.wait_time = active_duration

func _on_area_entered(area: Area2D) -> void:
	hp -= 1
	emit_signal("boss_damage_taken", hp)
	area.queue_free()
		
	if hp <= 0:
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
	var p = attack_patterns.instantiate()
	p.position = self.position
	emit_signal("spawn_pattern", p)
	Callable(p, boss_attacks.pick_random()).bind(3).call()
