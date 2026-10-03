extends CharacterBody2D

const SPEED = 800.0
const JUMP_SPEED = 800.0
@export var nombre:String 
@export var colorvisible:Color

func _ready() -> void:
	$CollisionShape2D.debug_color = colorvisible
	$Label.text = nombre

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var direction:float = 0.0
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if name == "Player1" and Input.is_action_just_pressed("p1UP") and is_on_floor():
		velocity.y = -JUMP_SPEED
		
	if name == "Player2" and Input.is_action_just_pressed("p2UP") and is_on_floor():
		velocity.y = -JUMP_SPEED


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if name == "Player1":
		direction = Input.get_axis("p1LEFT","p1RIGHT")
	else:
		direction = Input.get_axis("p2LEFT","p2RIGHT")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	
