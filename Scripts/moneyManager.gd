extends Control

signal money_changed(new_amount: int) #ça envoie un signal à tous les autres script qui sont abonnés
signal add_money(is_money_added: bool)
var money = 0;

func updateMoney(addValue) -> void:
	if addValue != 0:
		money += addValue
		money_changed.emit(money)
		add_money.emit(addValue > 0)
