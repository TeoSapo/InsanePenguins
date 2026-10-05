extends Control
const COPO_NIEVE = preload("res://Escenas/UI/copo_nieve.tscn")



func _ready() -> void:
	$p1Name.text = InsanePenguins.P1Name
	$p2Name.text = InsanePenguins.P2Name
	$p1Puntaje.text = str(InsanePenguins.P1Score)
	$p2Puntaje.text = str(InsanePenguins.P2Score)
	_ganador()

func _process(delta: float) -> void:
	pass
func _ganador():
	if InsanePenguins.P1Score > InsanePenguins.P2Score:
		$Ganador.text = "GANÓ " + InsanePenguins.P1Name + "!"
	elif InsanePenguins.P1Score < InsanePenguins.P2Score:
		$Ganador.text = "GANÓ " + InsanePenguins.P2Name + "!"
	else:
		$Ganador.text = "ES UN EMPATE!"



func _on_timer_timeout() -> void:
	var copoInstancia = COPO_NIEVE.instantiate()
	copoInstancia.position = Vector2(randi_range(get_viewport_rect().size.x, 0), -10 )
	add_child(copoInstancia)
