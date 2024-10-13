extends VBoxContainer

@export var name_label: Node
@export var healthbar: Node

func set_values(boss_name, hp):
	name_label.text = boss_name
	healthbar.max_value = hp
	healthbar.value = hp
	
func update_healthbar(hp):
	healthbar.value = hp
