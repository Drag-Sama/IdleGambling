extends PanelContainer


func _on_buy_button_pressed() -> void:
	MoneyManager.updateMoney(10)
