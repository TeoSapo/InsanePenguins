extends Node

signal Obtiene_Pescadito
signal Actualizar_Score


var P1Score:int = 0
var P2Score:int = 0
var P1Name:String = "TEO"
var P2Name:String = "JAZ"

func _ready() -> void:
	Obtiene_Pescadito.connect(on_Obtiene_Pescadito)
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
