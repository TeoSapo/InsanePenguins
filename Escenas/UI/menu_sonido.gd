extends Control


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUSICA"), linear_to_db(value))
	print(value)

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	$PinguinoGraznando.play()

func _on_volver_pressed() -> void:
	self.visible = false
