extends Control
@onready var music: HSlider = $Music
@onready var sfx: HSlider = $Sfx

func _ready():
	music.value=AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUSICA"))
	sfx.value=AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MUSICA"), linear_to_db(value))
	
func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	$PinguinoGraznando.play()

func _on_volver_pressed() -> void:
	self.visible = false
