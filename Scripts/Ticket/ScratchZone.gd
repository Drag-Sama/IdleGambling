extends Node2D

@onready var sub_viewport = $SubViewport
@onready var drawing = $SubViewport/Drawing
@onready var mask = $Mask

func _ready():
	mask.material = mask.material.duplicate() 
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_NEVER

func _process(_delta):
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
