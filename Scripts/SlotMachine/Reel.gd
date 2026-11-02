extends Control

const SYMBOL_HEIGHT := 52
const VISIBLE_SLOTS := 3

@export var symbols: Array[Texture2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var r := TextureRect.new()
	r.texture = symbols[0]
	r.size = Vector2(size.x, SYMBOL_HEIGHT)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(r)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
