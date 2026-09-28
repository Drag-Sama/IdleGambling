extends Node2D

@onready var sub_viewport = $SubViewport
@onready var drawing = $SubViewport/Drawing
@onready var mask = $Mask
@onready var result: TextureRect = $Result

const LOSE = preload("uid://by6hk74ygt2tq")
const WIN = preload("uid://dais0aocd0vqf")
const WIN_2 = preload("uid://btawhlyx8cd56")

const SPRITES = [LOSE, WIN, WIN_2]

signal revealed(value)
var is_selected = false

var already_won = false
const WIN_THRESHOLD = 60.0
var value = null 

func _ready():
	mask.material = mask.material.duplicate() 
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_NEVER
	var timer = Timer.new()
	timer.wait_time = 0.3  # vérifie 3 fois par seconde, ajustable
	timer.timeout.connect(_check_scratch_percentage)
	add_child(timer)
	timer.start()
	
	#Setup le sprite selon la valeur de la zone
	if(value < SPRITES.size()):
		result.texture = SPRITES[value]
	else:
		result.texture = SPRITES[0] #ça devrait pas arriver mais on sait jamais
		print("ERROR: Value not in range")

func _process(_delta): #Permet de gratter la zone
	if is_selected:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if mask.get_global_rect().has_point(get_global_mouse_position()):
				var local_pos = mask.get_local_mouse_position()
				if mask.size.x > 0 and mask.size.y > 0:
					var ratio = Vector2(sub_viewport.size) / mask.size
					local_pos *= ratio
					drawing.draw_at(local_pos)
		else:
			drawing.reset_stroke()
	
	await RenderingServer.frame_post_draw
	var tex = sub_viewport.get_texture()
	mask.material.set_shader_parameter("mask_texture", tex)
	
func _check_scratch_percentage(): #Vérifie le pourcentage de zone gratté
	if already_won:
		return
	
	var img = sub_viewport.get_texture().get_image()
	img.resize(64, 64, Image.INTERPOLATE_BILINEAR)
	
	var scratched_pixels = 0
	var total_pixels = 64 * 64
	
	for y in 64:
		for x in 64:
			if img.get_pixel(x, y).r > 0.5:
				scratched_pixels += 1
	
	var percentage = float(scratched_pixels) / float(total_pixels) * 100.0
	
	if percentage >= WIN_THRESHOLD:
		already_won = true
		revealed.emit(value)
		if(value != 0):
			reveale_animation()

func on_selected():
	is_selected = true

func reveale_animation():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.YELLOW, 0.2)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
