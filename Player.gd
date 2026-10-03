extends CharacterBody2D

const SPEED = 800.0
const JUMP_SPEED = 800.0
@export var nombre:String 
@export var colorvisible:Color
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$CollisionShape2D.debug_color = colorvisible
	$Label.text = nombre

func _physics_process(delta: float) -> void:

	var direction:float = 0.0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if name == "Player1" and Input.is_action_just_pressed("p1UP") and is_on_floor():
		velocity.y = -JUMP_SPEED
		
	if name == "Player2" and Input.is_action_just_pressed("p2UP") and is_on_floor():
		velocity.y = -JUMP_SPEED

	
	if name == "Player1":
		direction = Input.get_axis("p1LEFT","p1RIGHT")
	else:
		direction = Input.get_axis("p2LEFT","p2RIGHT")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	
