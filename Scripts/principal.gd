extends Node2D


func _ready():
	
	var Nivel = $HBoxContainer/VentanaP1/SubViewport.find_world_2d()
	$HBoxContainer/VentanaP2/SubViewport.world_2d = Nivel
	
	
	
	
