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

@export_range(0, 1) var indice_jugador = 0

func _ready() -> void:
	estado = "IDLE"
	#$Label.text = nombre 
	$Nombre.text = InsanePenguins.nombres[indice_jugador]

func _physics_process(delta: float) -> void:
	
	mover(delta,self)
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
		estado = "SALTANDO"
		
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
		
	sprite.flip_h = direction < 0


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
			
