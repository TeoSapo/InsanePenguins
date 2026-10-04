extends CharacterBody2D

const SPEED = 100
const JUMP_SPEED = 800.0
const SLIP_SPEED = 500

@export var nombre:String 
@export var colorvisible:Color
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$Label.text = nombre

func _physics_process(delta: float) -> void:
	
	mover_y_animar(delta,self)
	move_and_slide()
	
func mover_y_animar(delta,jugador: CharacterBody2D):
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
		sprite.play("Saltando")
	else:
		if direction:
			velocity.x = direction * SPEED
			sprite.play("Caminando")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			sprite.play("Idle")
			
		if Input.is_action_pressed(playerTecla+"DOWN"):
			$Collision.disabled = true
			$Collision2.disabled = false
			velocity.x = direction *  SLIP_SPEED
			sprite.play("Panzaso")
			
		
	
	if  Input.is_action_just_pressed(playerTecla+"UP") and is_on_floor():
		velocity.y = -JUMP_SPEED


	sprite.flip_h = direction < 0
