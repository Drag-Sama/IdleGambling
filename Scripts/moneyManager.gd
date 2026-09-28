extends Control

signal money_changed(new_amount: int) #ça envoie un signal à tous les autres script qui sont abonnés
var money = 0;

func updateMoney(addValue) -> void:
	money += addValue
	money_changed.emit(money)
