extends Node2D

var scratchZone = preload("res://Object/ScratchZone.tscn")

func _spawn(position):
	print("aaa")
	var scratchZone_instance = scratchZone.instantiate()
	scratchZone_instance.position = position
	scratchZone_instance.scale = Vector2(1.5, 1.5)
	add_child(scratchZone_instance)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_spawn(Vector2(0,0))
	_spawn(Vector2(300,-350))
	_spawn(Vector2(600,0))
