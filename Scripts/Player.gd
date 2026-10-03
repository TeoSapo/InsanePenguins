extends CharacterBody2D

const SPEED = 100
const JUMP_SPEED = 800.0
@export var nombre:String 
@export var colorvisible:Color
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$CollisionShape2D.debug_color = colorvisible
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
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if  Input.is_action_just_pressed(playerTecla+"UP") and is_on_floor():
		sprite.play("Saltando")
		velocity.y = -JUMP_SPEED
		
		

	direction = Input.get_axis(playerTecla+"LEFT",playerTecla+"RIGHT")

	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			sprite.play("Caminando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle")

	sprite.flip_h = direction < 0
