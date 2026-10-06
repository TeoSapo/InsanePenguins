extends Node

#@onready var p_1_score: Label = $P1Score
#@onready var p_2_score: Label = $P2Score

signal Obtiene_Pescadito
signal Actualizar_Score
signal No_hay_mas_tiempo
signal puntos_cambiados(indicePJ: int, valor: int)

const TIC:float = 0.6
const pathSave = "user://puntajes.json"
const maxRegistros = 5

var nombres: Array[String] = ["AAA", "AAA"]
var puntos: Array[int] = [0, 0]
var records: Array = [[], []]

#var P1Score:int = 0
#var P2Score:int = 0
#var P1Name:String = "TEO"
#var P2Name:String = "JAZ"

func _ready() -> void:
	Obtiene_Pescadito.connect(on_Obtiene_Pescadito)
	No_hay_mas_tiempo.connect(on_Final_Nivel)
	cargar_record()
	#P1Score = 0
	#P2Score = 0

func reiniciar_puntos() -> void:
	puntos = [0, 0]

func on_Obtiene_Pescadito(player:CharacterBody2D) -> void:
	var indice_jugador := 0 if player.name == "Player1" else 1
	sumar_puntos(indice_jugador)

func sumar_puntos(indice_jugador: int) -> void:
	puntos[indice_jugador] += 1
	puntos_cambiados.emit(indice_jugador, puntos[indice_jugador])
	Actualizar_Score.emit()

#func sumar_puntos(player:CharacterBody2D):
	#if player.name == "Player1":
		#InsanePenguins.P1Score += 1
	#else:
		#InsanePenguins.P2Score += 1
	#Actualizar_Score.emit()

func obtener_ganador() -> int:
	if puntos[0] > puntos[1]:
		return 0
	if puntos[1] > puntos[0]:
		return 1
	return -1

func on_Final_Nivel():
	print ("el nivel termino")
	guardar_puntaje()
	#get_tree().paused = true
	get_tree().change_scene_to_file("res://Escenas/UI/pantalla_final.tscn")

func guardar_puntaje() -> void:
	for j in 2:
		records[j].append({"nombre": nombres[j], "puntos": puntos[j]})
		records[j].sort_custom(func(a, b): return a["puntos"] > b["puntos"])
		if records[j].size() > maxRegistros:
			records[j].resize(maxRegistros)
	guardar_en_disco()

func guardar_en_disco() -> void:
	var archivo = FileAccess.open(pathSave, FileAccess.WRITE)
	archivo.store_string(JSON.stringify(records))

func cargar_record() -> void:
	if not FileAccess.file_exists(pathSave):
		return
	var datos = JSON.parse_string(FileAccess.get_file_as_string(pathSave))
	if datos is Array and datos.size() == 2:
		records = datos
		for lista in records:
			for r in lista:
				r["puntos"] = int(r["puntos"])
