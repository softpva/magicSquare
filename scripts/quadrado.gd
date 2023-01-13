extends Node2D

const CENTRO = 1
const BORDA = 0
var tipo = CENTRO setget setTipo
var valor setget setValor, getValor
var size setget setSize, getSize

func _ready():
	pass

func setColor(color):
	get_node("TextureButton").set_modulate(color)
	
func getColor():
	return get_node("TextureButton").get_modulate()


func setSize(val):
	set_scale(Vector2(val/180.0, val/180.0))
	size = val
#	set_node("TextureButton").set_size(Vector2(size,size))
	
func getSize():
	return size
	
func setTipo(val):
	tipo = val

func setValor(val):
	get_node("TextureButton/Label").set_text(str(val))
	valor = val

func getValor():
	return valor