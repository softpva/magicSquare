extends Node2D

var pressed = false
var drag = false
var posToqueAtual = Vector2(0, 0)
var posToqueAnterior = Vector2(0, 0)

func _ready():
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	if drag and posToqueAtual != posToqueAnterior and posToqueAnterior != Vector2(0, 0):
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(posToqueAnterior, posToqueAtual)
		if not result.empty():
			result.collider.cut()

func _input(event):
	event = make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

func pressed(pos):
	pressed = true
	posToqueAnterior = pos

func released():
	pressed = false
	drag = false
	posToqueAnterior = Vector2(0, 0)
	posToqueAtual = Vector2(0, 0)

func drag(pos):
	posToqueAtual = pos
	drag = true
