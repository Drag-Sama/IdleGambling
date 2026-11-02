extends Node

func _on_lever_button_pressed() -> void:
	$Lever.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lever_animation_finished() -> void:
	$Lever.frame = 0
