extends CharacterBody2D

signal bullet_fired(bullet_instance)
signal damage_taken(hp)
signal charges_changed(charges)

@export var sprite: Node
@export var anim: Node
@export var charge_cd: Node

var bullet = load("res://Scenes/Bullet.tscn")
var shoot_cd = 0.1
var can_shoot = true
var dodge_speed = 800
var normal_speed = 300
var input_direction = Vector2.ZERO
var hp = 10
var charges = 0
var charge_cd_progress = 0 # World reads this to send to UI

enum States {
	ACTIVE,
	DODGING
}
var state = States.ACTIVE

@onready var screen_size = get_viewport().size
@onready var sprite_width_scaled = sprite.texture.get_width() * self.transform.get_scale().x
@onready var sprite_height_scaled = sprite.texture.get_height() * self.transform.get_scale().y

func _ready() -> void:
	add_to_group("player")

func shoot():
	# Can add Input.is_action_pressed("shoot")
	if can_shoot:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = self.global_position
		emit_signal("bullet_fired", bullet_instance)
		can_shoot = false
		await get_tree().create_timer(shoot_cd).timeout
		can_shoot = true
		
func dodge():
	if charges > 0 and Input.is_action_pressed("dodge") and input_direction != Vector2.ZERO:
		charges -= 1
		emit_signal("charges_changed", charges)
		if input_direction.x >= 0:
			anim.play("dodge_right")
		elif input_direction.x < 0:
			anim.play("dodge_left")
		state = States.DODGING
		

func _process(delta: float) -> void:
	# If we have max charges, stop the cooldown bar at the max
	# If its stopped and we have less than 3, resume it
	if charges == 3:
		charge_cd.stop()
		charge_cd_progress = charge_cd.wait_time
	elif charge_cd.is_stopped() and charges < 3:
		charge_cd.start()
	# Update the progress for main to read and update bar
	charge_cd_progress = charge_cd.wait_time - charge_cd.time_left
	if state == States.ACTIVE:
		dodge()
		shoot()
	if state == States.DODGING:
		sprite.modulate = Color(0.282, 0.612, 1)
		if !anim.is_playing():
			sprite.modulate = Color(1, 1, 1)
			state = States.ACTIVE
			
func _physics_process(delta):
	if state == States.ACTIVE:
		input_direction = Input.get_vector("left", "right", "up", "down")
		input_direction = input_direction.normalized()
		velocity = input_direction * normal_speed 
		move_and_slide()
	if state == States.DODGING:
		velocity = input_direction * dodge_speed 
		move_and_slide()
		
	# Clamp the player to the screen
	position.x = clamp(position.x, 0+sprite_width_scaled/2, screen_size.x-sprite_width_scaled/2)
	position.y = clamp(position.y, 0+sprite_height_scaled/2, screen_size.y-sprite_height_scaled/2)

func _on_charge_cooldown_timeout() -> void:
	charges += 1
	emit_signal("charges_changed", charges)

func _on_area_2d_area_entered(area: Area2D) -> void:
	hp -= area.get_damage()
	emit_signal("damage_taken", hp)
	area.queue_free()
