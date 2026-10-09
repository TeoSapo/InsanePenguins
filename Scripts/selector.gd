extends HBoxContainer

@onready var etiquetas := [$Letra1, $Letra2, $Letra3]

func mostrar(texto: String, posicion: int, activo: bool) -> void:
	for i in 3:
		etiquetas[i].text = texto[i]
		etiquetas[i].modulate = Color(1.033, 0.818, 0.497, 1.0) if (activo and i == posicion) else Color.WHITE 
		
