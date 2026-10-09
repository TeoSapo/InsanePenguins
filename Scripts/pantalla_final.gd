extends Control
#Lo comente por que me tiraba error
const COPO_NIEVE = preload("res://Escenas/CLASES/copo_nieve.tscn")
@onready var confetti_ganador_1: GPUParticles2D = $ConfettiGanador1
@onready var confetti_ganador_2: GPUParticles2D = $ConfettiGanador2


func _ready() -> void:
	$p1Name.text = InsanePenguins.nombres[0]
	$p2Name.text = InsanePenguins.nombres[1]
	$p1Puntaje.text = str(InsanePenguins.puntos[0])
	$p2Puntaje.text = str(InsanePenguins.puntos[1])
	_ganador()

func _ganador() -> void:
	match InsanePenguins.obtener_ganador():
		0:
			confetti_ganador_1.emitting = true
			$Ganador.text = "GANÓ " + InsanePenguins.nombres[0] + "!"
		1:
			confetti_ganador_2.emitting = true
			$Ganador.text = "GANÓ " + InsanePenguins.nombres[1] + "!"
		_:
			$Ganador.text = "ES UN EMPATE!"
			confetti_ganador_1.emitting = true
			confetti_ganador_2.emitting = true
	
	#if InsanePenguins.P1Score > InsanePenguins.P2Score:
		#confetti_ganador_1.emitting = true
		#$Ganador.text = "GANÓ " + InsanePenguins.P1Name + "!"
	#elif InsanePenguins.P1Score < InsanePenguins.P2Score:
		#confetti_ganador_2.emitting = true
		#$Ganador.text = "GANÓ " + InsanePenguins.P2Name + "!"
	#else:
		#$Ganador.text = "ES UN EMPATE!"
		#confetti_ganador_1.emitting = true
		#confetti_ganador_2.emitting = true


func _on_timer_timeout() -> void:
	var copoInstancia = COPO_NIEVE.instantiate()
	copoInstancia.position = Vector2(randi_range(get_viewport_rect().size.x, 0), -10 )
	add_child(copoInstancia)


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/UI/Menu_Principal.tscn")
