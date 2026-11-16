extends PanelContainer

@onready var label: RichTextLabel = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	print(get_children())
	
func _place_next_to(button: Control) -> void :
	var rect := button.get_global_rect()
	var screen := get_viewport_rect().size
	var pos := Vector2(rect.end.x + 8, rect.position.y)
	pos.x = min(pos.x, screen.x - size.x)
	pos.y = clamp(pos.y, 0.0, screen.y - size.y)
	global_position = pos

func show_for(upg: UpgradeData, button:Control) -> void:
	label.text = "[font_size=11]%s\nBonus actuel : +%s" % [upg.description, UpgradeManager.get_bonus(upg.effect_id)]
	reset_size()
	show()
	await get_tree().process_frame
	reset_size()
	_place_next_to(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
