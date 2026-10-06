extends HBoxContainer

@onready var etiquetas := [$Letra1, $Letra2, $Letra3]

func mostrar(texto: String, posicion: int, activo: bool) -> void:
	for i in 3:
		etiquetas[i].text = texto[i]
		etiquetas[i].modulate = Color.YELLOW if (activo and i == posicion) else Color.WHITE 
