extends Control

@export var charges: Array[Node]
@export var healthbar: Node
@export var dodgebar: Node
@export var score: Node
@export var highscore: Node

func update_healthbar(hp):
	healthbar.value = hp

func update_dodgebar(progress):
	dodgebar.value = progress
	
func update_charges(charge_count):
	for i in range(charges.size()):
		var color
		if charge_count > i:
			color = Color(0.559, 0.616, 0.849) # "Has charge" colpr
		else:
			color = Color(0.6, 0.6, 0.6) # "No charge" color
			
		charges[i].get_theme_stylebox("panel").bg_color = color
			
func update_score():
	highscore.text = "Highscore: "+str(Autoload.highscore)
	score.text = "Score: "+str(Autoload.score)
	
	
