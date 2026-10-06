extends Node

#@onready var p_1_score: Label = $P1Score
#@onready var p_2_score: Label = $P2Score


signal Obtiene_Pescadito
signal Actualizar_Score
signal No_hay_mas_tiempo

const TIC:float = 0.6

var P1Score:int = 0
var P2Score:int = 0
var P1Name:String = "TEO"
var P2Name:String = "JAZ"

func _ready() -> void:
	Obtiene_Pescadito.connect(on_Obtiene_Pescadito)
	No_hay_mas_tiempo.connect(on_Final_Nivel)
	P1Score = 0
	P2Score = 0

	
func on_Obtiene_Pescadito(player:CharacterBody2D):
	sumar_puntos(player)
	
	
func sumar_puntos(player:CharacterBody2D):
	if player.name == "Player1":
		InsanePenguins.P1Score += 1
	else:
		InsanePenguins.P2Score += 1
	Actualizar_Score.emit()

func on_Final_Nivel():
	print ("el nivel termino")
	#get_tree().paused = true
	get_tree().change_scene_to_file("res://Escenas/UI/pantalla_final.tscn")
	
	
	
