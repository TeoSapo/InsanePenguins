extends Node



signal Obtiene_Pescadito
signal Actualizar_Score
signal No_hay_mas_tiempo
signal puntos_cambiados(indicePJ: int, valor: int)
signal recolectar_nieve

const TIC:float = 0.6
const maxRegistros = 5
const pathSave = "user://puntajes.json"
const PESCADITO = preload("res://Escenas/CLASES/Pescadito.tscn")
const MONTON_NIEVE = preload("res://Escenas/CLASES/Monton_Nieve.tscn")

const TILE_SIZE:Vector2i = Vector2i(32,32)
const TILE_SCALE:float = 2.5


var nombres: Array[String] = ["P01", "P02"]
var puntos: Array[int] = [0, 0]
var records: Array = [[], []]
var tiles_disponibles:Array[Vector2i]

func _ready() -> void:
	Obtiene_Pescadito.connect(on_Obtiene_Pescadito)
	No_hay_mas_tiempo.connect(on_Final_Nivel)
	cargar_record()

func reiniciar_puntos() -> void:
	puntos = [0, 0]

func on_Obtiene_Pescadito(player:CharacterBody2D) -> void:
	sumar_puntos(player.indice_jugador)

func sumar_puntos(indice_jugador: int) -> void:
	puntos[indice_jugador] += 1
	puntos_cambiados.emit(indice_jugador, puntos[indice_jugador])
	Actualizar_Score.emit()

func obtener_ganador() -> int:
	if puntos[0] > puntos[1]:
		return 0
	if puntos[1] > puntos[0]:
		return 1
	return -1


func saber_ubicacion_tilemap(tiles):
	var celdas_usadas: Array[Vector2i] = tiles.get_used_cells()
	for coordenada in celdas_usadas:
		var id_fuente = tiles.get_cell_source_id(coordenada)
		var coord_atlas = tiles.get_cell_atlas_coords(coordenada)
		if id_fuente == 0 and coord_atlas == Vector2i.RIGHT:
			tiles_disponibles.append(coordenada)

func instanciar_pescado(nivel):
	var max_tiles:int = tiles_disponibles.size()-1
	var indice_pescado:int = -1
	indice_pescado = randi_range(0,max_tiles)
	
	var nuevo_pescado:Node2D = PESCADITO.instantiate()

	nuevo_pescado.indice_tile_asociado = indice_pescado
	nuevo_pescado.position.x = int(TILE_SIZE.x/2.0) + TILE_SIZE.x * TILE_SCALE * tiles_disponibles[indice_pescado].x
	nuevo_pescado.position.y = int(-TILE_SIZE.y/2.0) + TILE_SIZE.y * TILE_SCALE * tiles_disponibles[indice_pescado].y
	nivel.add_child(nuevo_pescado)

func instanciar_monton_de_nieve(nivel):
	var max_tiles:int = tiles_disponibles.size()-1
	var indice_monton:int = 1
	
	indice_monton = randi_range(0,max_tiles)
	
	var nuevo_monton:Node2D = MONTON_NIEVE.instantiate()

	nuevo_monton.indice_tile_asociado = indice_monton
	nuevo_monton.position.x = int(TILE_SIZE.x/2.0) + TILE_SIZE.x * TILE_SCALE * tiles_disponibles[indice_monton].x
	nuevo_monton.position.y = int(-TILE_SIZE.y/2.0) + TILE_SIZE.y * TILE_SCALE * tiles_disponibles[indice_monton].y
	nivel.add_child(nuevo_monton)


#region Final, puntajes - guardado y recuperación

func on_Final_Nivel():

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
#endregion
