extends Node

var main_menu = load("res://Scenes/main_menu.tscn")
var world = load("res://Scenes/world.tscn")
var interface = load("res://Scenes/interface.tscn")

@onready var mm_instance = main_menu.instantiate()

func _ready() -> void:
	self.add_child(mm_instance)
	mm_instance.start_game.connect(start_game)

func load_scene(scene) -> Node:
	var scene_instance = scene.instantiate()
	self.add_child(scene_instance)
	return scene_instance
	
func start_game():
	mm_instance.queue_free()
	
	var world_instance = load_scene(world)
	var interface_instance = load_scene(interface)
	world_instance.update_score.connect(interface_instance.update_score)
	world_instance.update_charges.connect(interface_instance.update_charges)
	world_instance.update_healthbar.connect(interface_instance.update_healthbar)
	world_instance.update_dodgebar.connect(interface_instance.update_dodgebar)
	interface_instance.update_score()
	
