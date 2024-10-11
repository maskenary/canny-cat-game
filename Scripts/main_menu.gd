extends Control

signal start_game

@export var start_button: Node
@export var credits_button: Node
@export var exit_button: Node

func _ready() -> void:
	start_button.grab_focus()
	
func _on_start_button_pressed() -> void:
	emit_signal("start_game")

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
