extends Control

const LETRAS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const PREFIJOS := ["p1", "p2"]

var indices = [[0, 0, 0], [0, 0, 0]]
var posiciones = [0, 0]
var listos = [false, false]

@onready var selectores = [%SelectorJ1, %SelectorJ2]

func _ready() -> void:
	for j in 2:
		actualizar(j)

func _unhandled_input(event: InputEvent) -> void:
	for j in 2:
		if not listos[j] and procesar_jugadores(j, event):
			actualizar(j)
			if listos[0] and listos[1]:
				empezar_nivel()
			return

func procesar_jugadores(j: int, event: InputEvent) -> bool:
	var p: String = PREFIJOS[j]
	
	if event.is_action_pressed(p + "DOWN"):
		indices[j][posiciones[j]] = (indices[j][posiciones[j]] + 1) % LETRAS.length()
	elif event.is_action_pressed(p + "UP"):
		indices[j][posiciones[j]] = (indices[j][posiciones[j]] - 1 + LETRAS.length()) % LETRAS.length()
	elif event.is_action_pressed(p + "LEFT"):
		posiciones[j] = max(posiciones[j] - 1, 0)
	elif event.is_action_pressed(p + "SHOOT"):
		if posiciones[j] < 2:
			posiciones[j] += 1
		else: 
			listos[j] = true
	else:
		return false
	return true

func obtener_nombres(j: int) -> String:
	var nombre = ""
	for i in indices[j]:
		nombre += LETRAS[i]
	return nombre

func actualizar(j: int) -> void:
	selectores[j].mostrar(obtener_nombres(j), posiciones[j], not listos[j])

func empezar_nivel() -> void:
	for j in 2:
		InsanePenguins.nombres[j] = obtener_nombres(j)
	get_tree().change_scene_to_file("res://Escenas/JUEGO/Nivel1.tscn")
