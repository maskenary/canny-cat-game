extends Control

@export var start_button: Node
@export var credits_button: Node
@export var exit_button: Node

var main_node = preload("res://Scenes/main.tscn").instantiate()

func _ready() -> void:
	start_button.grab_focus()

func _on_start_button_pressed() -> void:
	

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
