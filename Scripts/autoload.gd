extends Node

var score = 0
var highscore = 0

func add_score(value):
	score += value
	if score > highscore:
		highscore = score
		
func clear_score():
	score = 0

signal update_score
signal clear_enemies
signal player_died
