extends Area2D

var speed = 200
var score_value = 10

signal score_changed

func set_score_value(value):
	score_value = value

func _physics_process(delta: float) -> void:
	position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	Autoload.add_score(score_value)
	emit_signal("score_changed")
	self.queue_free()
	
	
