extends Node2D

# Nests: refatorar(nomes, varGlobais); pontuaçãoEstrelasEtc, Som

const MAGICO = -1
const CALCULAR_A_OBTER = 0
const CALCULAR_RESULTADOS = 1
var sizeMalhaInterna = 3 setget setSizeMalhaInterna
var quadradoSize = 140 setget private
var matrizInterna = [] setget private
var matrizResposta = [] # para futura implementação de dicas
var escopoInterno = [] setget private
var metasColunas = []
var metasLinhas = []
var respostasColunas = []
var respostasLinhas = []
var dictQuad = {}
var posAreaInterna
var posFimAreaInterna
var isDrag = false
var posToqueAtual = Vector2(0, 0)
var posToqueAnterior = Vector2(0, 0)
var posIni = Vector2(0, 0)
var posFim = Vector2(0, 0)
var fase = 1
var vitoriaPorFase = 0
var pontos = 0
onready var msg = get_node("../Tela/Msg")
var Quad = preload("res://scenes/quadrado.tscn")

func _ready():
	set_process_input(true)
	jogar()

func _input(event):
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

func pressed(pos):
	posToqueAnterior = pos

func released():
	if isInInternalSquare():
		msg.set_text("")
		trocaNumeros()
		get_node("SamplePlayer2D").play("passouFase")
	isDrag = false
	posToqueAnterior = Vector2(0, 0)
	posToqueAtual = Vector2(0, 0)

func drag(pos):
	posToqueAtual = pos
	isDrag = true
	if isInInternalSquare():
		dictQuad[posIni].setColor(Color(1,1,0))
		if fase > 0 and pontos > 200:
			get_node("../Tela/Dica").set_hidden(false)


func _on_Dica_pressed():
	if ! get_node("../Tela/Dica").is_hidden():
		var l = 0
		var linha = ""
		pontos -= 100
		if pontos < 0:
			pontos = 0
		l = int(rand_range(0, sizeMalhaInterna))
		if matrizResposta[0][0] != 0:
			linha = "Linha "+str(l+1)+" =  "
			for i in range(sizeMalhaInterna):
				linha += str(matrizResposta[l][i]) + "  "
		else:
			linha = " Dica para números mágicos"
		msg.set_text(linha)
		get_node("../Tela/Dica").set_hidden(true)
		get_node("../Tela/Pontos").set_text(str(pontos))

func isInInternalSquare():
	if isDrag and posToqueAtual != posToqueAnterior and posToqueAnterior != Vector2(0, 0):
		if posToqueAnterior.x > posAreaInterna.x and posToqueAnterior.x < posFimAreaInterna.x \
		and posToqueAnterior.y > posAreaInterna.y and posToqueAnterior.y < posFimAreaInterna.y:
			if posToqueAtual.x > posAreaInterna.x and posToqueAtual.x < posFimAreaInterna.x \
			and posToqueAtual.y > posAreaInterna.y and posToqueAtual.y < posFimAreaInterna.y:
				posIni = ((posToqueAnterior-posAreaInterna)/quadradoSize).floor()
				posFim = ((posToqueAtual-posAreaInterna)/quadradoSize).floor()
				var posPrv = posFim
				return true 
	return false

func trocaNumeros():
	var numIni = matrizInterna[posIni.y][posIni.x]
	var numFim = matrizInterna[posFim.y][posFim.x]
	matrizInterna[posIni.y][posIni.x] = numFim
	matrizInterna[posFim.y][posFim.x] = numIni
	pontos -= 10
	if pontos < 0:
		pontos = 0
	obterResultados()
#	aObter(CALCULAR_RESULTADOS)
	setView()

func obterMetas():
	var res = somarLinhaColunasDiagonais(sizeMalhaInterna)
	metasLinhas = res[0]
	metasColunas = res[1]


func obterNumeroMagico():
	var s = sizeMalhaInterna
	var numMagico = s * ( s * s + 1 ) / 2
	metasLinhas = matriz(sizeMalhaInterna+1,1, numMagico)
	metasColunas = matriz(sizeMalhaInterna+1,1, numMagico)
	

func obterResultados():
	var res = somarLinhaColunasDiagonais(sizeMalhaInterna)
	respostasLinhas = res[0]
	respostasColunas = res[1]
	if respostasLinhas == metasLinhas and respostasColunas == metasColunas:
		vitoriaPorFase += 1
		msg.set_text("                          G A N H O U ! ! !")
		get_node("Timer").start()
	setView()

func _on_Timer_timeout():
	msg.set_text("")
	get_node("SamplePlayer2D").play("passouFase2")
	jogar()

func somarLinhaColunasDiagonais(s):
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


func jogar():
	if vitoriaPorFase == 2:
		vitoriaPorFase =0
		fase+= 1
	if fase == 1:
		sizeMalhaInterna = 2
	elif fase == 2:
		sizeMalhaInterna = 3
	elif fase == 3:
		sizeMalhaInterna = 4
	elif fase == 4:
		sizeMalhaInterna = 5
	else:
		get_tree().reload_current_scene()
	if vitoriaPorFase % 2 == 1 and fase != 1:
		inicializeVariaveis()
		obterNumeroMagico()
		matrizResposta = matriz(sizeMalhaInterna)
	else:
		inicializeVariaveis()
		obterMetas()
		matrizResposta = matrizInterna + []
	inicializeVariaveis()
	obterResultados()

func inicializeVariaveis():
	randomize()
	quadradoSize = int(get_viewport().get_size_override().x / (sizeMalhaInterna + 2)) - 4
	posAreaInterna = Vector2( (get_viewport().get_size_override().x - quadradoSize*(sizeMalhaInterna+2))/2,200)	
	set_pos(posAreaInterna)
	posAreaInterna += Vector2(quadradoSize,quadradoSize)
	posFimAreaInterna = posAreaInterna+Vector2(sizeMalhaInterna*quadradoSize,sizeMalhaInterna*quadradoSize)
	escopoInterno = range (1,(1+pow(sizeMalhaInterna,2)))
	matrizInterna = createMap()

func matriz(ordemX, ordemY = ordemX, elemento = 0):
	var matriz = []
	for x in range(ordemX):
		if ordemY != 1:
			matriz.append([])
		for y in range(ordemY):
			if ordemY != 1:
				matriz[x].append(elemento)
			else:
				matriz.append(elemento)
	return matriz
	
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

# ***********************   VIEW  ********************************

func setView():
	for x in range(-1, sizeMalhaInterna+1):
		for y in range(-1, sizeMalhaInterna+1):
			var quad = Quad.instance()
			quad.set_pos( Vector2((x+1)*quadradoSize, (y+1)*quadradoSize))
			quad.size = quadradoSize
			if (x >= 0 and x < sizeMalhaInterna and y >= 0 and y < sizeMalhaInterna):
				quad.valor = matrizInterna[y][x]
				quad.setColor(Color(0.8,1,0))
			elif ( y == -1 and x >= 0 ):
				quad.valor = metasColunas[x]
				quad.setColor(Color(0,1,1))
			elif ( x == sizeMalhaInterna and y >= 0):
				quad.valor = metasLinhas[y]
				quad.setColor(Color(0,1,1))
			elif ( y == sizeMalhaInterna and x < sizeMalhaInterna ):
				quad.valor = respostasColunas[x]
				if respostasColunas[x] == metasColunas[x]:
					if quad.getColor() != Color(0,1,0):
						pontos += 10
					quad.setColor(Color(0,1,0))
				else:
					quad.setColor(Color(1,0,0))
			elif ( x == -1 and y < sizeMalhaInterna ):
				quad.valor = respostasLinhas[y]
				if respostasLinhas[y] == metasLinhas[y]:
					if quad.getColor() != Color(0,1,0):
						pontos += 10
					quad.setColor(Color(0,1,0))
				else:
					quad.setColor(Color(1,0,0))
			add_child(quad)
			dictQuad[Vector2(x,y)] = quad 
			get_node("../Tela/Pontos").set_text(str(pontos))

# **************************  CONTROLLER / SETGETs  ***********************

func private(val):
	print("Variável privada, não pode ser alterada externamente!")
	
func setSizeMalhaInterna(val):
	if val < 3:
		sizeMalhaInterna = 3
	elif val > 5:
		sizeMalhaInterna = 5
	else:
		sizeMalhaInterna = val

#   *****************************  PRV   *******************************

#func aObter(tipo):
#	var s = sizeMalhaInterna
#	if s ==2 and tipo == MAGICO:
#		tipo = CALCULAR_A_OBTER
#	if tipo == CALCULAR_A_OBTER:
#		var res = somarLinhaColunasDiagonais(s)
#		metasLinhas = res[0]
#		metasColunas = res[1]
#		print("metasLinhas= ", metasLinhas)
#		print("metasColunas= ", metasColunas)
#	elif tipo == CALCULAR_RESULTADOS:
#		var res = somarLinhaColunasDiagonais(s)
#		respostasLinhas = res[0]
#		respostasColunas = res[1]
#		if respostasLinhas == metasLinhas and respostasColunas == metasColunas:
#			vitoriaPorFase += 1
#			msg.set_text("                     G A N H O U ! ! !")
#			get_node("Timer").start()
#		print("respostasLinhas= ", respostasLinhas)
#		print("respostasColunas= ", respostasColunas)
#	elif tipo == MAGICO:
#		var s = sizeMalhaInterna
#		var numMagico = s * ( s * s + 1 ) / 2
#		metasLinhas = matriz(sizeMalhaInterna+1,1, numMagico)
#		metasColunas = matriz(sizeMalhaInterna+1,1, numMagico)
#		print("metasLinhas= ", metasLinhas)
#		print("metasColunas= ", metasColunas)