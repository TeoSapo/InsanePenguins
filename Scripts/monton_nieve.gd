extends Node2D

@onready var indice_tile_asociado:int

@onready var estado:int = $AnimatedSprite2D.frame

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	estado = 5


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.estado != "PANZASO":
		await get_tree().create_timer(0.2).timeout
		consumir_nieve()
		InsanePenguins.recolectar_nieve.emit()
	else:
		#romper monton de nieve con explosion
		pass

func consumir_nieve():
	if estado>0:
		estado -= 1
	else:
		queue_free()
