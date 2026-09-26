extends Node2D

var scratchZone = preload("res://Object/ScratchZone.tscn")
@onready var background: TextureRect = $Background

const CONTAINER_SIZE = 640
const INSTANCE_COUNT = 3
const BACKGROUND_COLORS = [0x2ba2fb, 0x25e854, 0xe1ca32] #Pour faire des tickets de couleur random plus tard mais ça marche pas trop pour le moment

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	#Cette ligne change la couleur de manière random mais c'est bizarre, tu peux essayer stv
	#background.self_modulate = Color.hex(BACKGROUND_COLORS.pick_random()) 
	
	var space = CONTAINER_SIZE / (INSTANCE_COUNT - 1)
	for i in range(INSTANCE_COUNT):
		_spawn(Vector2(space * i, 200))

func _spawn(pos: Vector2):
	var scratchZone_instance = scratchZone.instantiate()
	scratchZone_instance.position = pos
	#scratchZone_instance.scale = Vector2(e_factor)
	background.add_child(scratchZone_instance)
