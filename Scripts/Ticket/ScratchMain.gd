extends Node2D

var scratchZone = preload("res://Object/ScratchZone.tscn")
@onready var background: TextureRect = $Background
@onready var claim: Button = $Claim

const CONTAINER_SIZE = 640
const INSTANCE_COUNT = 3 #Nombre de zone
const BACKGROUND_COLORS = [0x2ba2fbff, 0x25e854ff, 0xe1ca32ff] #Pour faire des tickets de couleur random plus tard mais ça marche pas trop pour le moment

var _is_selected: bool = false

@export var hold_threshold: float = 0.2 #Temps qu'il faut maintenant pour qu'on Drag le ticket
var _is_holding: bool = false
var _is_dragging: bool = false
var _drag_offset: Vector2 = Vector2.ZERO
var _hold_timer: Timer

var _zone_revealed = 0 #Nombre de zone révélé
var _ticket_value = 0 #Valeur total du ticket

var _max_zone_value = 2 #Nombre de dessin qu'il peut y avoir pour une zone 
var _min_zone_value = 0 #Valeur minimal, c'est au cas ou on fait une upgrade qui empeche de tomber sur une zone vide
var _value_proba = [40, 30, 30] #Proba de chaque valeur

signal is_selected()

static var current_selected: Node = null

func _can_interact() -> bool:
	return current_selected == null or current_selected == self

func _ready():
	claim.pivot_offset = claim.size / 2 #Place le centre de rotation de claim (ça servira pour l'animation)
	claim.visible = false #Claim est caché par défaut
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	background.position = -background.size / 2 #Centre le background( ça servira pour l'animation)
	claim.position = Vector2(-claim.size.x / 2, (-claim.size.y / 2) + 550) #Place claim

	background.self_modulate = Color.hex(BACKGROUND_COLORS.pick_random()) #Choisi une couleur random pour le background
	
	#Setup pour Drag an drop
	_hold_timer = Timer.new() 
	_hold_timer.wait_time = hold_threshold
	_hold_timer.one_shot = true
	_hold_timer.timeout.connect(_on_hold_timeout)
	add_child(_hold_timer)
	
	#Fait spawn les zones
	var space = CONTAINER_SIZE / (INSTANCE_COUNT - 1)
	for i in range(INSTANCE_COUNT):
		_spawn(Vector2(space * i, 200))

func _get_random_value(): #Renvoie la valeur d'une zone selon les propabilités
	var random_value = randi_range(1, 100)
	var proba = 0
	for i in range(_min_zone_value, _max_zone_value+1):
		proba += _value_proba[i]
		if random_value <= proba:
			return i
	return 0 #Normalement ça devrait jamais servir mais on sait jamais
		

func _spawn(pos: Vector2): #Fais spawn une zone
	var scratchZone_instance = scratchZone.instantiate()
	scratchZone_instance.position = pos
	scratchZone_instance.value = _get_random_value()
	scratchZone_instance.revealed.connect(_on_zone_revealed)
	self.is_selected.connect(scratchZone_instance.on_selected)
	background.add_child(scratchZone_instance)

func _on_zone_revealed(value): #Quand une zone est suffisament révélé
	_ticket_value = _ticket_value + value
	_zone_revealed += 1
	if _zone_revealed == INSTANCE_COUNT:
		if _ticket_value == _max_zone_value * INSTANCE_COUNT:
			print("JACKPOT")
			_ticket_value = _ticket_value * 3
		claim.visible = true
		claim.text = "Claim(" + str(_ticket_value) + ")" 
		

func _on_background_gui_input(event: InputEvent) -> void: #Se déclenche quand on clique sur le ticket
	if not _can_interact():
		return  # un autre ticket est sélectionné

	if event is InputEventMouseButton && !_is_selected:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				self.z_index = 0
				_is_holding = false
				_is_dragging = false
				_hold_timer.start()
				# Décalage entre le clic et le centre de l'objet, pour éviter un "saut"
				_drag_offset = global_position - get_global_mouse_position()
			else:
				if _hold_timer.time_left > 0 and not _is_dragging: #Quand on clique
					_hold_timer.stop()
					_is_selected = true
					current_selected = self 
					is_selected.emit()
					_selected_animation()
				
				_is_holding = false
				_is_dragging = false

	elif event is InputEventMouseMotion:
		if _is_dragging:
			global_position = get_global_mouse_position() + _drag_offset

func _on_hold_timeout() -> void: #Quand on maintient le clique sur le ticket
	if !_is_selected:
		self.z_index = 1
		_is_holding = true
		_is_dragging = true
		
func _selected_animation() -> void: #Animation quand on clique sur le ticket
	self.z_index = 10
	
	var target_scale = 0.5
	var target_position = get_viewport_rect().size / 2

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)

	tween.tween_property(self, "global_position", Vector2(target_position.x, target_position.y - 100), 0.4)
	tween.tween_property(self, "rotation", 0.0, 0.4)
	tween.tween_property(self, "scale", Vector2(target_scale, target_scale), 0.4)


func _on_claim_pressed() -> void: #Quand on claim le ticket
	MoneyManager.updateMoney(_ticket_value)
	
	claim.disabled = true
	
	var tween = create_tween()

	tween.tween_property(claim, "scale", Vector2(1.4, 1.4), 0.08)
	tween.parallel().tween_property(claim, "rotation", 0.14, 0.08)

	tween.tween_property(claim, "scale", Vector2(1, 1), 0.2)
	tween.parallel().tween_property(claim, "rotation", -0.14, 0.2)
	
	
	tween.tween_property(self, "scale", Vector2(0,0) , 0.1)
	
	await tween.finished

	self.queue_free()

func _exit_tree() -> void: #Lorsqu'on supprime le ticket
	if current_selected == self:
		current_selected = null
