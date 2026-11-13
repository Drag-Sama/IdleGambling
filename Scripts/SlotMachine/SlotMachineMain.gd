extends Node

var reels: Array[Reel] = []
	
func _on_lever_button_pressed() -> void:
	$Lever.play()
	for reel in reels :
		reel.spin(reel.current_symbols[0])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Reel:
			reels.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lever_animation_finished() -> void:
	$Lever.frame = 0
