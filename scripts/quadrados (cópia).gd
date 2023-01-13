extends Node2D

const MAGICO = -1
const CALCULAR_A_OBTER = 0
const CALCULAR_RESULTADOS = 1
var sizeMalhaInterna = 5 setget setSizeMalhaInterna
var quadradoSize = 140 setget private
var matrizInterna = [] setget private
var escopoInterno = [] setget private
var aObterColuna = []
var aObterLinha = []
var respostaColuna = []
var respostaLinha = []
var dictQuad = {}
var posAreaInterna
var pressed = false
var drag = false
var posToqueAtual = Vector2(0, 0)
var posToqueAnterior = Vector2(0, 0)
var posIni = Vector2(0, 0)
var posFim = Vector2(0, 0)
var Quad = preload("res://scenes/quadrado.tscn")

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	inicializeVariaveis(MAGICO)
	inicializeVariaveis(CALCULAR_RESULTADOS)

func _fixed_process(delta):
	var posFimAreaInterna = posAreaInterna+Vector2(sizeMalhaInterna*quadradoSize,sizeMalhaInterna*quadradoSize)
	if drag and posToqueAtual != posToqueAnterior and posToqueAnterior != Vector2(0, 0):
		if posToqueAnterior.x > posAreaInterna.x and posToqueAnterior.x < posFimAreaInterna.x \
		and posToqueAnterior.y > posAreaInterna.y and posToqueAnterior.y < posFimAreaInterna.y:
			if posToqueAtual.x > posAreaInterna.x and posToqueAtual.x < posFimAreaInterna.x \
			and posToqueAtual.y > posAreaInterna.y and posToqueAtual.y < posFimAreaInterna.y:
				posIni = ((posToqueAnterior-posAreaInterna)/quadradoSize).floor()
				posFim = ((posToqueAtual-posAreaInterna)/quadradoSize).floor()
				

				print("posIni: ", posIni)
				print("posFim: ", posFim)

	
func _input(event):
#	event = make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
			print("Soltou")
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

func pressed(pos):
	pressed = true
	posToqueAnterior = pos
	

func released():
	var prv
	pressed = false
	drag = false
	posToqueAnterior = Vector2(0, 0)
	posToqueAtual = Vector2(0, 0)
	trocaNumeros()

	
func trocaNumeros():
	var numIni = matrizInterna[posIni.x][posIni.y]
	var numFim = matrizInterna[posFim.x][posFim.y]
	print(numIni)
	print(numFim)
	matrizInterna[posIni.x][posIni.y] = numFim
	matrizInterna[posFim.x][posFim.y] = numIni
	print(matrizInterna)
	aObter(CALCULAR_RESULTADOS)
	setView()
	
	

func drag(pos):
	posToqueAtual = pos
	drag = true


func inicializeVariaveis(tipo):
	randomize()
	quadradoSize = int(get_viewport().get_size_override().x / (sizeMalhaInterna + 2)) - 4	
	print("quadradoSize: ", quadradoSize)
	posAreaInterna = Vector2( (get_viewport().get_size_override().x - quadradoSize*(sizeMalhaInterna+2))/2,200)
	set_pos(posAreaInterna)
	posAreaInterna += Vector2(quadradoSize,quadradoSize)
	escopoInterno = range (1,(1+pow(sizeMalhaInterna,2)))
	matrizInterna = createMap()
	print(matrizInterna)
	aObter(tipo)
	if tipo == CALCULAR_RESULTADOS:
		setView()
	
func createMap():
	var escopo = escopoInterno + []
	var map = []
	for x in range(sizeMalhaInterna):
		map.append([])
		for y in range(sizeMalhaInterna):
			var i = randi() % escopo.size()
			map[x].append(escopo[i])
			escopo.remove(i)
	return map

func aObter(tipo):
	var s = sizeMalhaInterna
	if s ==2 and tipo == MAGICO:
		tipo = CALCULAR_A_OBTER
	if tipo == CALCULAR_A_OBTER:
		var res = calcule(s)
		aObterLinha = res[0]
		aObterColuna = res[1]
		print("aObterLinha= ", aObterLinha)
		print("aObterColuna= ", aObterColuna)
	elif tipo == CALCULAR_RESULTADOS:
		var res = calcule(s)
		respostaLinha = res[0]
		respostaColuna = res[1]
		print("respostaLinha= ", respostaLinha)
		print("respostaColuna= ", respostaColuna)
	elif tipo == MAGICO:
		var s = sizeMalhaInterna
		var numMagico = s * ( s * s + 1 ) / 2
		aObterLinha = matriz(sizeMalhaInterna+1,1, numMagico)
		aObterColuna = matriz(sizeMalhaInterna+1,1, numMagico)
		print("aObterLinha= ", aObterLinha)
		print("aObterColuna= ", aObterColuna)

func calcule(s):
	var somaLinha = matriz(s+1,1)
	var somaColuna = matriz(s+1,1)
	for x in range(s):
		for y in range(s):
			if x == y :
				somaLinha[s] += matrizInterna[x][y]
			if x == s-y-1:
				somaColuna[s] += matrizInterna[x][y]
			somaLinha[x] += matrizInterna[x][y]
			somaColuna[y] += matrizInterna[x][y]
	return [somaLinha, somaColuna]

func matriz(ordemX, ordemY = ordemX, elemento = 0):
	var matriz = []
	for x in range(ordemX):
		for y in range(ordemY):
			matriz.append(elemento)
	return matriz

func setView():
	for x in range(-1, sizeMalhaInterna+1):
		for y in range(-1, sizeMalhaInterna+1):
			var quad = Quad.instance()
			quad.set_pos( Vector2((x+1)*quadradoSize, (y+1)*quadradoSize))
#			quad.get_node("TextureButton/Label").set_text(str(x)+","+str(y))
#			quad.get_node("TextureButton").set_size(Vector2(300,300))
			quad.size = quadradoSize
#			quad.get_node("TextureButton").set_size(Vector2(quadradoSize,quadradoSize))
#			quad.set_scale(Vector2(quadradoSize/140,quadradoSize/140))
			if (x >= 0 and x < sizeMalhaInterna and y >= 0 and y < sizeMalhaInterna):
				quad.valor = matrizInterna[y][x]
#				quad.get_node("TextureButton/Label").set_text(str(matrizInterna[y][x]))
				quad.get_node("TextureButton").set_modulate(Color(1,1,0))
			elif ( y == -1 and x >= 0 ):
				quad.get_node("TextureButton/Label").set_text(str(aObterColuna[x]))
				quad.get_node("TextureButton").set_modulate(Color(0,1,1))
			elif ( x == sizeMalhaInterna and y >= 0):
				quad.get_node("TextureButton/Label").set_text(str(aObterLinha[y]))
				quad.get_node("TextureButton").set_modulate(Color(0,1,1))
			elif ( y == sizeMalhaInterna and x < sizeMalhaInterna ):
				quad.get_node("TextureButton/Label").set_text(str(respostaColuna[x]))
				if respostaColuna[x] == aObterColuna[x]:
					quad.get_node("TextureButton").set_modulate(Color(0,1,0))
				else:
					quad.get_node("TextureButton").set_modulate(Color(1,0,0))
			elif ( x == -1 and y < sizeMalhaInterna ):
				quad.get_node("TextureButton/Label").set_text(str(respostaLinha[y]))
				if respostaLinha[y] == aObterLinha[y]:
					quad.get_node("TextureButton").set_modulate(Color(0,1,0))
				else:
					quad.get_node("TextureButton").set_modulate(Color(1,0,0))
			add_child(quad)
			dictQuad[Vector2(x,y)] = quad 
#			print(Vector2(x,y), " : ", dictQuad[Vector2(x,y)].get_node("TextureButton/Label").get_text())


func private(val):
	print("Variável privada, não pode ser alterada externamente!")
	
func setSizeMalhaInterna(val):
	if val < 3:
		sizeMalhaInterna = 3
	elif val > 5:
		sizeMalhaInterna = 5
	else:
		sizeMalhaInterna = val
