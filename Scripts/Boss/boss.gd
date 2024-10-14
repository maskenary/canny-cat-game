extends Area2D

signal boss_damage_taken(hp)
signal boss_died

@export var anim_player: Node
@export var sprite: Node
@export var active_timer: Node
var boss_name = "Uncatty, The Rotter of Neurons"
var hp = 100
var speed = 600
var active_timelength = 5

# Set from creator
var boss_positions = []
var boss_positions_index = 0

enum States {
	ACTIVE,
	MOVING,
}
var state = States.MOVING;
var target_position = Vector2.ZERO

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
			state = States.ACTIVE
			
	elif state == States.ACTIVE:
		sprite.modulate = Color(1, 1, 1)
		animate_self("idle")

		
func _physics_process(delta: float) -> void:
	if state == States.MOVING:
		var move_dir = position.direction_to(target_position)
		var x_movement = move_dir.x * speed * delta
		var y_movement = move_dir.y * speed * delta
		if target_position.x - position.x < x_movement:
			position.x = target_position.x
		else:
			position.x += x_movement 
			
		if target_position.y - position.y < x_movement:
			position.y = target_position.y
		else:
			position.y += y_movement 
			
		
	

func _on_active_timer_timeout() -> void:
	boss_positions_index+=1
	var next_position = boss_positions[boss_positions_index]
	set_target_position(next_position.x, next_position.y)
	state = States.MOVING
