extends Node2D

@onready var p1_score: Label = $P1Score
@onready var p2_score: Label = $P2Score
@onready var tiempo_juego: Node = $TiempoJuego/Tiempo
@onready var player_1: CharacterBody2D = $HBoxContainer/VentanaP1/SubViewport/Player1
@onready var player_2: CharacterBody2D = $HBoxContainer/VentanaP2/SubViewport/Player2
@onready var dibujo_nivel: Node = $HBoxContainer/VentanaP1/SubViewport/DibujoNivel

@onready var tile_map: Node = $HBoxContainer/VentanaP1/SubViewport/DibujoNivel/TileMapLayer


func _ready():
	InsanePenguins.reiniciar_puntos()
	InsanePenguins.Actualizar_Score.connect(actualizar_puntos)
	
	# duplica el mundo en el subviewport del player 2
	player_1.position = $HBoxContainer/VentanaP1/SubViewport/DibujoNivel/P1Start.position
	player_2.position = $HBoxContainer/VentanaP1/SubViewport/DibujoNivel/P2Start.position
	
	InsanePenguins.saber_ubicacion_tilemap(tile_map)
	for i in range(0,41):
		InsanePenguins.instanciar_pescado(dibujo_nivel)
	
	for i in range(0,11):
		InsanePenguins.instanciar_monton_de_nieve(dibujo_nivel)
	
	var Nivel = $HBoxContainer/VentanaP1/SubViewport.find_world_2d()
	$HBoxContainer/VentanaP2/SubViewport.world_2d = Nivel
	
	actualizar_puntos()


func actualizar_puntos():
	p1_score.text=InsanePenguins.nombres[0] + ": " + str(InsanePenguins.puntos[0])
	p2_score.text=InsanePenguins.nombres[1] + ": " + str(InsanePenguins.puntos[1])


func _on_timer_nivel_timeout() -> void:
	tiempo_juego.value -= InsanePenguins.TIC
	if tiempo_juego.value <= 0:
		InsanePenguins.No_hay_mas_tiempo.emit()
