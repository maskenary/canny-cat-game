extends Control

signal start_game

@export var yes_button: Node

func _ready() -> void:
	yes_button.grab_focus()

func _on_yes_button_pressed() -> void:
	self.queue_free()
	emit_signal("start_game")

func _on_no_button_pressed() -> void:
	get_tree().quit()
