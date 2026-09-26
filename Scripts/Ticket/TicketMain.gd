extends PanelContainer

var ticket = preload("res://Object/Ticket.tscn")

func _on_buy_button_pressed() -> void:
	MoneyManager.updateMoney(-10)
	var ticket_instance = ticket.instantiate()
	ticket_instance.position = Vector2(0,200)
	ticket_instance.scale = Vector2(0.3, 0.3)
	add_child(ticket_instance)
