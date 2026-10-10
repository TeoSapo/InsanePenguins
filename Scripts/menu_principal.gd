extends Control

@onready var sonido_ui: AudioStreamPlayer = $SonidoUI


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/JUEGO/pantalla_nombres.tscn")
	
	
func _on_sonidos_pressed() -> void:
	$MenuSonido.visible = true


func _on_creditos_pressed() -> void:
	$PantallaCreditos.visible = true



func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_ruidito_menu():
	sonido_ui.play()
