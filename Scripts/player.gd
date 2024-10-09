extends CharacterBody2D

signal bullet_fired(bullet_instance)

const bullet = preload("res://Scenes/Bullet.tscn")
var shoot_cd = 0.2
var can_shoot = true
var dodge_speed = 800
var normal_speed = 400
var input_direction = Vector2.ZERO

enum States {
	ACTIVE,
	DODGING
}
var state = States.ACTIVE
@onready var screen_size = get_viewport().size
@onready var sprite = $Sprite2D
@onready var sprite_width_scaled = sprite.texture.get_width() * self.transform.get_scale().x
@onready var sprite_height_scaled = sprite.texture.get_height() * self.transform.get_scale().y
@onready var anim = $AnimationPlayer
	
func shoot():
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = self.global_position
		emit_signal("bullet_fired", bullet_instance)
		can_shoot = false
		await get_tree().create_timer(shoot_cd).timeout
		can_shoot = true
		
func dodge():
	if Input.is_action_pressed("dodge") and input_direction != Vector2.ZERO:
		anim.play("dodge")
		state = States.DODGING
		

func _process(delta: float) -> void:
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
		velocity = input_direction * normal_speed 
		move_and_slide()
	if state == States.DODGING:
		velocity = input_direction * dodge_speed 
		move_and_slide()
		
	# Clamp the player to the screen
	position.x = clamp(position.x, 0+sprite_width_scaled/2, screen_size.x-sprite_width_scaled/2)
	position.y = clamp(position.y, 0+sprite_height_scaled/2, screen_size.y-sprite_height_scaled/2)
