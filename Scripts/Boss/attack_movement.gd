extends Node

var speed = null
var direction = null

func set_movement(direction, speed):
	direction = direction
	speed = speed
	
func _physics_process(delta: float) -> void:
	if speed != null and direction != null:
		self.position += direction*speed*delta
	print(direction)
	print(speed)
