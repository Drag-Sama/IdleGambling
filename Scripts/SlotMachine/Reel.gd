extends Control

const VISIBLE_SLOTS := 3
const DIR_SYMBOLS = "res://Assets/Sprite/SlotMachine/Machine/Reels/"
const SYMBOLS = ["7","10","dollar"]

@export var current_symbols: Array[Texture2D] = []

func get_texture_symbol(symbol: String) -> Texture2D :
	var path = DIR_SYMBOLS.path_join(symbol+".png")
	return load(path)

func get_random_symbol() -> String:
	return SYMBOLS[randi_range(0, SYMBOLS.size() - 1)] if SYMBOLS.size() > 0 else null

# remplissage de "symbols" de façon aléatoire
func remplir_symbols() -> void :
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
		
		y_offset += height


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
