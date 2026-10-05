extends Control



func _ready() -> void:
	$p1Name.text = InsanePenguins.P1Name
	$p2Name.text = InsanePenguins.P2Name
	$p1Puntaje.text = str(InsanePenguins.P1Score)
	$p2Puntaje.text = str(InsanePenguins.P2Score)
