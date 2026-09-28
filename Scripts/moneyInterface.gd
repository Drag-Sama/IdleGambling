extends Control

@onready var money_label: Label = $MarginContainer/Background/MarginContainer/HBoxContainer/Sidebar/Money

var bump_tween: Tween
var start_pos : Vector2

func _ready() -> void:
	MoneyManager.money_changed.connect(_on_money_changed)
	MoneyManager.add_money.connect(_on_money_changed_animation)
	_on_money_changed(MoneyManager.money) 
	
	await get_tree().process_frame #Attend que le texte soit bien placé
	start_pos = money_label.position

func _on_money_changed(new_amount: int) -> void:
	money_label.text = "Money: " + str(new_amount)

func _on_money_changed_animation(is_money_added :bool): #Animation du texte quand on gagne / perde de l'argent
	if bump_tween:
		bump_tween.kill()

	money_label.pivot_offset = money_label.size / 2
	money_label.scale = Vector2.ONE
	money_label.position = start_pos
	
	var color = Color.YELLOW if is_money_added else Color.RED
	
	var vector = Vector2(1.2, 1.2) if is_money_added else Vector2(0.8, 0.8)
	
	var pos = Vector2(0,-10) if is_money_added else Vector2(0, 10)
	
	bump_tween = create_tween().set_parallel(true)
	bump_tween.tween_property(money_label, "scale", vector , 0.1)
	bump_tween.tween_property(money_label, "position", start_pos + pos, 0.1)
	bump_tween.tween_property(money_label, "modulate", color, 0.1)
	bump_tween.chain().tween_property(money_label, "scale", Vector2.ONE, 0.2)
	bump_tween.parallel().tween_property(money_label, "modulate", Color.WHITE, 0.2)
	bump_tween.parallel().tween_property(money_label, "position", start_pos, 0.15)
