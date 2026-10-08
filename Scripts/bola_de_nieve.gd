extends Area2D

const animEntera = "Entera"
const animBolaRompiendo = "BolaRompiendo"

enum Lado {der, izq, arriba, abajo}

@export_group("Trayectoria")
@export_range(0, 89) var anguloG = 45
@export var velInicial = 700
@export var gravedad = 900
@export var duracion = 4

@export_group("Anim de romperse")
@export var ladoAnim: Lado = Lado.der
@export var radioBola = 5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rayCast: RayCast2D = $RayCast2D

var velocidad = Vector2.ZERO
var lanzador: Pinguino
var vida =0
var rompiendose = false
var posAnterior = Vector2.ZERO
var paso = Vector2.ZERO

func _ready() -> void:
	vida = duracion
	rayCast.enabled = false
	sprite.play(animEntera)


func iniciar(dirrecion: int, lanz: Pinguino) -> void:
	lanzador = lanz
	rayCast.add_exception(lanz)
	var angulo = deg_to_rad(anguloG)
	velocidad = Vector2(cos(angulo) * dirrecion, -sin(angulo)) * velInicial
	posAnterior = global_position
	paso = velocidad * get_physics_process_delta_time()


func _physics_process(delta: float) -> void:
	if rompiendose:
		return
	
	velocidad.y += gravedad * delta
	posAnterior = global_position
	paso = velocidad * delta
	global_position += paso
	
	vida -= delta
	if vida <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if rompiendose or body == lanzador:
		return
	rompiendose = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	var pinguino = body as Pinguino
	if pinguino:
		pinguino.recibir_impacto()
	
	var normal = buscarNormal()
	var dir = direccionCardinal(-normal)
	sprite.rotation = vectorBase().angle_to(dir)
	
	if sprite.sprite_frames.has_animation(animBolaRompiendo):
		sprite.play(animBolaRompiendo)
	else:
		queue_free()


func buscarNormal() -> Vector2:
	var dir = paso.normalized()
	rayCast.global_position = posAnterior
	rayCast.target_position = dir * (paso.length() + radioBola * 2)
	rayCast.force_raycast_update()
	
	if rayCast.is_colliding():
		var normal = rayCast.get_collision_normal()
		global_position = rayCast.get_collision_point() + normal * radioBola
		return normal
	
	return -dir

func direccionCardinal(v: Vector2) -> Vector2:
	if absf(v.x) > absf(v.y):
		return Vector2(signf(v.x), 0)
	return Vector2(0, signf(v.y))

func vectorBase() -> Vector2:
	match  ladoAnim:
		Lado.arriba:
			return Vector2.UP
		Lado.abajo:
			return Vector2.DOWN
		Lado.izq:
			return Vector2.LEFT
	return Vector2.RIGHT

func _on_animated_sprite_2d_animation_finished() -> void:
	if rompiendose:
		queue_free()
