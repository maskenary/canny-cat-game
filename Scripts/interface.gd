extends Control

@onready var charges = [$DodgeCharges/Charge1, $DodgeCharges/Charge2, $DodgeCharges/Charge3]
@onready var healthbar = $HealthBar
@onready var dodgebar = $DodgeBar

func update_healthbar(hp):
	healthbar.value = hp

func update_dodgebar(progress):
	dodgebar.value = progress
	
func update_charges(charge_count):
	for i in range(charges.size()):
		var color
		if charge_count > i:
			color = Color(0, 0.565, 1) # "Has charge" colpr
		else:
			color = Color(0.6, 0.6, 0.6) # "No charge" color
			
		charges[i].get_theme_stylebox("panel").bg_color = color
			
	
	
	
