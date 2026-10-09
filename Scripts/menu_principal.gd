extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_pressed() -> void:
	$pantallaNombres.visible = true
	


func _on_sonidos_pressed() -> void:
	$MenuSonido.visible = true


func _on_creditos_pressed() -> void:
	$PantallaCreditos.visible = true


func _on_salir_pressed() -> void:
	get_tree().quit()
