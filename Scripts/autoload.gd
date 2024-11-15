extends Node

var score = 0
var highscore = 0

func add_score(value):
	score += value
	if score > highscore:
		highscore = score

signal clear_enemies
