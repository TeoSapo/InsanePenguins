extends Node2D

@onready var p1_score: Label = $P1Score
@onready var p2_score: Label = $P2Score

func _ready():

	# duplica el mundo en el subviewport del player 2
	var Nivel = $HBoxContainer/VentanaP1/SubViewport.find_world_2d()
	$HBoxContainer/VentanaP2/SubViewport.world_2d = Nivel
	
	InsanePenguins.P1Score = 0
	InsanePenguins.P2Score = 0
	actualizar_puntos()
	InsanePenguins.Actualizar_Score.connect(actualizar_puntos)
	
func actualizar_puntos():
	p1_score.text=InsanePenguins.P1Name+":"+str(InsanePenguins.P1Score)
	p2_score.text=InsanePenguins.P2Name+":"+str(InsanePenguins.P2Score)
