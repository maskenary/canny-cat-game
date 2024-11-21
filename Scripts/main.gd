extends Node

var main_menu = load("res://Scenes/main_menu.tscn")
var world = load("res://Scenes/world.tscn")
var interface = load("res://Scenes/interface.tscn")
var gameover = load("res://Scenes/game_over.tscn")

@onready var mm_instance = main_menu.instantiate()

var world_instance = null
var interface_instance = null

func _ready() -> void:
	Autoload.player_died.connect(player_died)
	self.add_child(mm_instance)
	mm_instance.start_game.connect(start_game)

func player_died():
	if world_instance != null:
		world_instance.get_tree().paused = true
		var game_over_instance = load_scene(gameover)
		game_over_instance.start_game.connect(start_game)
	

func load_scene(scene) -> Node:
	var scene_instance = scene.instantiate()
	self.add_child(scene_instance)
	return scene_instance
	
func start_game():
	if world_instance != null:
		world_instance.queue_free()
	if interface_instance != null:
		interface_instance.queue_free()
	world_instance = load_scene(world)
	world_instance.get_tree().paused = false
	interface_instance = load_scene(interface)
	world_instance.update_charges.connect(interface_instance.update_charges)
	world_instance.update_healthbar.connect(interface_instance.update_healthbar)
	world_instance.update_dodgebar.connect(interface_instance.update_dodgebar)
	Autoload.clear_score()
	Autoload.emit_signal("update_score")
