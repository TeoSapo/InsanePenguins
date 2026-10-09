extends Node2D

@onready var indice_tile_asociado:int

func _on_area_2d_body_entered(body: Node2D) -> void:
	InsanePenguins.Obtiene_Pescadito.emit(body)
	queue_free()
	
