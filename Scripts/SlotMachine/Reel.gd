extends Control

class_name Reel

signal spin_finished

const VISIBLE_SLOTS := 3
const DIR_SYMBOLS = "res://Assets/Sprite/SlotMachine/Machine/Reels/"
const SYMBOLS = ["7","10","dollar"]

@export var current_symbols: Array[Texture2D] = []

########## GETTERS ############

func get_texture_symbol(symbol: String) -> Texture2D :
	var path = DIR_SYMBOLS + symbol + ".png"
	return load(path)

########### AFFICHAGE ###########

# remplissage de "symbols" de façon aléatoire
func remplir_symbols() -> void :
	current_symbols.clear()
	for i in VISIBLE_SLOTS :
		var symbol = SYMBOLS[randi_range(0,SYMBOLS.size()-1)]
		current_symbols.append(get_texture_symbol(symbol))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remplir_symbols()
	
	var bg := ColorRect.new()
	bg.color = Color.WHITE
	bg.size = size
	bg.position = Vector2.ZERO
	add_child(bg)
	
	var y_offset := 0.0
	for i in VISIBLE_SLOTS :
		var height : float
		if i == 1 :
			height = size.y * 0.5
		else :
			height = size.y * 0.25
			
		var reel := TextureRect.new()
		reel.texture = current_symbols[i]
		reel.size = Vector2(size.x, height)
		reel.position = Vector2(0,y_offset)
		reel.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		reel.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(reel)
		reel_rects.append(reel)
		y_offset += height

################ ANIMATION REEL #################

var reel_rects: Array[TextureRect] = []
var scroll_offset := 0.0
var tween : Tween
var get_next_symbol: Callable

func upd_reel_positions() -> void:
	var base_positions = [0.0, size.y * 0.25, size.y * 0.75]
	var heights = [size.y * 0.25,size.y * 0.5,size.y * 0.25]
	for i in reel_rects.size() :
		var reel = reel_rects[i]
		var old_y = reel.position.y
		var new_y = fmod(base_positions[i] + scroll_offset, size.y)
		if new_y < old_y : #il vient de boucler (retombé en haut)
			reel.texture = get_next_symbol.call()
		reel.position.y = new_y

func _on_spin_finished() -> void:
	reel_rects[1].texture = final_result
	spin_finished.emit()

func _on_scroll_update(value: float) -> void:
	scroll_offset = value
	upd_reel_positions()

var final_result: Texture2D

func spin(result: Texture2D) -> void:
	final_result = result
	var nb_tours := 30
	var duree := 2.0
	var cible := scroll_offset + nb_tours * size.y
	
	tween = create_tween()
	tween.tween_method(_on_scroll_update,scroll_offset,cible,duree)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_spin_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
