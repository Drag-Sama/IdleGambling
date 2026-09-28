extends Node2D

var last_pos = null
var current_pos = null
var scratch_radius = 100

func _draw():
	if current_pos == null:
		return
	if last_pos == null:
		draw_circle(current_pos, scratch_radius, Color.WHITE)
	else:
		draw_line(last_pos, current_pos, Color.WHITE, scratch_radius * 2)
		draw_circle(current_pos, scratch_radius, Color.WHITE) # arrondit les extrémités

func draw_at(pos):
	last_pos = current_pos
	current_pos = pos
	queue_redraw()

func reset_stroke():
	last_pos = null
	current_pos = null
