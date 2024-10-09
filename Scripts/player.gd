extends CharacterBody2D

signal bullet_fired(bullet_instance)

const bullet = preload("res://Scenes/Bullet.tscn")
var can_shoot = true
var speed = 500
enum States {
	ACTIVE,
	DODGING
}
var state = States.ACTIVE
@onready var screen_size = get_viewport().size
@onready var sprite_width_scaled = $Sprite2D.texture.get_width() * transform.get_scale().x
@onready var sprite_height_scaled = $Sprite2D.texture.get_height() * transform.get_scale().y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func move():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	move_and_slide()
	
func shoot():
	if Input.is_action_pressed("ui_accept") and can_shoot:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = self.global_position
		emit_signal("bullet_fired", bullet_instance)
		can_shoot = false
		await get_tree().create_timer(0.2).timeout
		can_shoot = true

func _physics_process(delta):
	if state == States.ACTIVE:
		move()
		shoot()
		
	# Clamp the player to the screen
	position.x = clamp(position.x, 0+sprite_width_scaled/2, screen_size.x-sprite_width_scaled/2)
	position.y = clamp(position.y, 0+sprite_height_scaled/2, screen_size.y-sprite_height_scaled/2)
