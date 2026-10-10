extends Node2D
class_name MontanaNieve

const nieveMax = 6

@export var bolasPorRecarga = 2
@export var tiempoRecoleccion = 2
@export var tiempoRegen = 6
@export var debugMontana = false

@onready var indice_tile_asociado:int
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var timerRecoleecion: Timer = $TimerRecoleccion
@onready var timerRegeneracion: Timer = $TimerRegeneracion

var jugadorRecolectando: Pinguino = null
var jugadorCerca: Array[Pinguino] = []
var regenerando = false

func _ready() -> void:
	timerRecoleecion.wait_time = tiempoRecoleccion
	timerRegeneracion.wait_time = tiempoRegen


func _physics_process(delta: float) -> void:
	for p in jugadorCerca:
		if p.estado == "PANZASO":
			destruir(p.indice_jugador)
			return
	
	if jugadorRecolectando != null and not puede_recolectar(jugadorRecolectando):
		soltar_recolector()
	
	if jugadorRecolectando == null and sprite.frame > 0:
		for p in jugadorCerca:
			if puede_recolectar(p):
				jugadorRecolectando = p
				timerRecoleecion.start()
				if debugMontana:
					print("Montaña: recarga " + p.name)
				break


func puede_recolectar(p: Pinguino) -> bool:
	return p.estado == "IDLE" and p.nieveActual < p.nieveMax - .01

func soltar_recolector() -> void:
	jugadorRecolectando = null
	timerRecoleecion.stop()

func _on_timer_recoleccion_timeout() -> void:
	if jugadorRecolectando == null or sprite.frame <= 0:
		soltar_recolector()
		return
	sprite.frame -= 1
	jugadorRecolectando.recargarBolas(bolasPorRecarga)
	InsanePenguins.recolectar_nieve.emit(jugadorRecolectando.indice_jugador) 
	#agarraNieve.emit(jugadorRecolectando.indice_jugador)
	if sprite.frame == 0:
		soltar_recolector()
		regenerando = true
		timerRegeneracion.start()

func _on_timer_regeneracion_timeout() -> void:
	sprite.frame += 1
	if sprite.frame >= nieveMax:
		regenerando = false
		timerRegeneracion.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:	
	if body is Pinguino and not jugadorCerca.has(body):
		jugadorCerca.append(body)
		if debugMontana:
			print("Montaña: entro " + body.name)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Pinguino:
		jugadorCerca.erase(body)
		if debugMontana: 
			print("Montaña: salio" + body.name)
		if body == jugadorRecolectando:
			soltar_recolector()

func destruir(indiceJugador) -> void:
	soltar_recolector()
	InsanePenguins.choqueMonton.emit(indiceJugador)
	queue_free()
