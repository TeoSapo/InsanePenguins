extends CharacterBody2D
class_name Pinguino
signal nieve_Reload(actual: float, maxima: float)

const SPEED = 200
const JUMP_SPEED = 800.0
const SLIP_SPEED = 500
# Estados > "IDLE","CAMINANDO","SALTANDO","PANZASO","CONGELADO","NOQUEADO","DESCONGELANDO"
@onready var estado 
@export var nombre:String 
@export var colorvisible:Color
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonidoSFX: AudioStreamPlayer = $AudioStreamPlayer
@onready var puntoMarker2D: Marker2D = $PuntoDeDisparo

@export_range(0, 1) var indice_jugador = 0

@export_group("Bola de nieve")
@export var escena_Bola: PackedScene
@export var nieveMax = 100
@export var nieveInicial = 100
@export var bolasMax = 5
@export var cdDisparrow = 1
@export var frameLanz = 4

@export_group("Freezer")
@export var bolasParaCongelar = 3
@export var tiempoParaDescongelar = 2

var nieveActual = 0
var costoBola = 20
var cdRestante = 0
var impactosRecibidos = 0
var tiempoMov = 0
var dirMirada = 1
var _prefijo = ""
var puntoDisparrow = 0

func _ready() -> void:
	estado = "IDLE"
	#$Label.text = nombre 
	$Nombre.text = InsanePenguins.nombres[indice_jugador]
	_prefijo = "p1" if name == "Player1" else "p2"
	puntoDisparrow = absf(puntoMarker2D.position.x)
	costoBola = nieveMax / maxi(bolasMax, 1)
	nieveActual = clampf(nieveInicial, 0, nieveMax)
	nieve_Reload.emit(nieveActual, nieveMax)


func _physics_process(delta: float) -> void:
	cdRestante = maxf(cdRestante - delta, 0)
	actualizarCongelado(delta)
	
	mover(delta,self)
	intentar_lanzar()
	animar(self)
	move_and_slide()


func mover(delta,jugador: CharacterBody2D):
	var direction:float = 0.0
	var playerTecla:String
	
	match jugador.name:
		"Player1":
			playerTecla = "p1"
		"Player2": 
			playerTecla = "p2"
	
	direction = Input.get_axis(playerTecla+"LEFT",playerTecla+"RIGHT")
	
	# Dos colisiones por cambio de sprite (panzaso)
	$Collision.disabled = false
	$Collision2.disabled = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not esta_bloqueado():
			estado = "SALTANDO"
	
	if esta_bloqueado():
		velocity.x = 0
		return
	
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			estado = "CAMINANDO"
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			estado ="IDLE"
	
	if Input.is_action_pressed(playerTecla+"DOWN"):
		$Collision.disabled = true
		$Collision2.disabled = false
		if velocity.x != 0:
			velocity.x = direction *  SLIP_SPEED
			estado = "PANZASO"
	
	if  Input.is_action_just_pressed(playerTecla+"UP") and is_on_floor():
		sonidoSFX.play()
		velocity.y = -JUMP_SPEED
		estado = "SALTANDO"
	
	#sprite.flip_h = direction < 0
	if direction != 0:
		dirMirada = 1 if direction > 0 else -1
	sprite.flip_h = dirMirada < 0
	puntoMarker2D.position.x = puntoDisparrow * dirMirada


func animar(jugador:CharacterBody2D):
	match estado:
		"IDLE":
			sprite.play("Idle")
		"SALTANDO":
			sprite.play("Saltando")
		"CAMINANDO":
			sprite.play("Caminando")	
		"PANZASO":
			sprite.play("Panzaso")
		"LANZANDO":
			sprite.play("Lanzando")
		"CONGELADO":
			sprite.play("Congelado")
		"DESCONGELADO":
			sprite.play("Descongelar")


func esta_bloqueado() -> bool:
	return estado == "LANZANDO" or estado == "CONGELADO" or estado == "DESCONGELADO"


func intentar_lanzar() -> void:
	if not Input.is_action_just_pressed(_prefijo + "SHOOT"):
		return
	if esta_bloqueado() or estado == "PANZASO" or not is_on_floor():
		return
	if cdRestante > 0 or nieveActual < costoBola -.01:
		return
	
	nieveActual -= costoBola
	cdRestante = cdDisparrow
	nieve_Reload.emit(nieveActual, nieveMax)
	
	velocity.x = 0
	estado = "LANZANDO"


func _on_animated_sprite_2d_animation_finished() -> void:
	if estado == "LANZANDO":
		estado = "IDLE"
	elif estado == "DESCONGELADO":
		estado = "IDLE"


func lanza_bola() -> void:
	if escena_Bola == null:
		push_warning("Falta escena de la bola de nieve !")
		return
	var bola = escena_Bola.instantiate()
	get_parent().add_child(bola)
	bola.global_position = puntoMarker2D.global_position
	bola.iniciar(dirMirada, self)


func recargarBolas(cantidad: float) -> void:
	if nieveActual >= nieveMax:
		return
	nieveActual = minf(nieveActual + cantidad * costoBola, nieveMax)
	nieve_Reload.emit(nieveActual, nieveMax)

func recibir_impacto() -> void:
	if estado == "CONGELADO" or estado == "DESCONGELADO":
		return
	impactosRecibidos += 1
	if impactosRecibidos >= bolasParaCongelar:
		congelar()


func congelar() -> void:
	impactosRecibidos = 0
	tiempoMov = 0
	velocity.x = 0
	estado = "CONGELADO"


func actualizarCongelado(delta: float) -> void:
	if estado != "CONGELADO":
		return
	var intento = Input.get_vector(_prefijo + "LEFT", _prefijo + "RIGHT", _prefijo + "UP", _prefijo + "DOWN")
	if intento != Vector2.ZERO:
		tiempoMov += delta
		if tiempoMov >= tiempoParaDescongelar:
			estado = "DESCONGELADO"

func _on_animated_sprite_2d_frame_changed() -> void:
	if estado != "LANZANDO":
		return
	if sprite.frame == frameLanz:
		lanza_bola()
