extends Node2D

var scratchZone = preload("res://Object/ScratchZone.tscn")
@onready var background: TextureRect = $Background

const CONTAINER_SIZE = 640
const INSTANCE_COUNT = 3
const BACKGROUND_COLORS = [0x2ba2fb, 0x25e854, 0xe1ca32] #Pour faire des tickets de couleur random plus tard mais ça marche pas trop pour le moment

var _is_selected: bool = false

@export var hold_threshold: float = 0.2
var _is_holding: bool = false
var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _hold_timer: Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	background.position = -background.size / 2
	#Cette ligne change la couleur de manière random mais c'est bizarre, tu peux essayer stv
	#background.self_modulate = Color.hex(BACKGROUND_COLORS.pick_random()) 
	
	_hold_timer = Timer.new()
	_hold_timer.wait_time = hold_threshold
	_hold_timer.one_shot = true
	_hold_timer.timeout.connect(_on_hold_timeout)
	add_child(_hold_timer)
	
	var space = CONTAINER_SIZE / (INSTANCE_COUNT - 1)
	for i in range(INSTANCE_COUNT):
		_spawn(Vector2(space * i, 200))

func _spawn(pos: Vector2):
	var scratchZone_instance = scratchZone.instantiate()
	scratchZone_instance.position = pos
	background.add_child(scratchZone_instance)


func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_is_holding = false
				_is_dragging = false
				_hold_timer.start()
				# Décalage entre le clic et le centre de l'objet, pour éviter un "saut"
				_drag_offset = global_position - get_global_mouse_position()
				print("Bouton gauche pressé à ", event.position)
			else:
				if _hold_timer.time_left > 0 and not _is_dragging:
					_hold_timer.stop()
					print("Clic simple détecté")
					_is_selected = true
					_selected_animation()
				else:
					print("Fin du déplacement")
				_is_holding = false
				_is_dragging = false

	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position = get_global_mouse_position() + _drag_offset

func _on_hold_timeout() -> void:
	if !_is_selected:
		_is_holding = true
		_is_dragging = true
		print("Clic maintenu détecté (en cours...)")
		
func _selected_animation() -> void:
	var target_scale = 0.5
	var target_position = get_viewport_rect().size / 2

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)

	tween.tween_property(self, "global_position", target_position, 0.4)
	tween.tween_property(self, "rotation", 0.0, 0.4)
	tween.tween_property(self, "scale", Vector2(target_scale, target_scale), 0.4)
