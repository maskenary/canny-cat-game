extends Node

var speed = null
var direction = null

func set_movement(direction, speed):
	self.direction = direction
	self.speed = speed
	
func _physics_process(delta: float) -> void:
	self.position += direction*speed*delta
