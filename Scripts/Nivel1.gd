extends Node2D

@onready var p1_score: Label = $P1Score
@onready var p2_score: Label = $P2Score
@onready var tiempo_juego: Node = $TiempoJuego/Tiempo

func _ready():

	InsanePenguins.Actualizar_Score.connect(actualizar_puntos)
	
	# duplica el mundo en el subviewport del player 2
	var Nivel = $HBoxContainer/VentanaP1/SubViewport.find_world_2d()
	$HBoxContainer/VentanaP2/SubViewport.world_2d = Nivel
	
	InsanePenguins.P1Score = 0
	InsanePenguins.P2Score = 0
	actualizar_puntos()
	
	
	
func actualizar_puntos():
	p1_score.text=InsanePenguins.P1Name+":"+str(InsanePenguins.P1Score)
	p2_score.text=InsanePenguins.P2Name+":"+str(InsanePenguins.P2Score)


func _on_timer_nivel_timeout() -> void:
	tiempo_juego.value -= 0.6
	print(tiempo_juego.value)
	pass # Replace with function body.
