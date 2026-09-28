extends Control

@onready var money_label: Label = $MarginContainer/Background/MarginContainer/HBoxContainer/Sidebar/Money

func _ready() -> void:
	MoneyManager.money_changed.connect(_on_money_changed)
	_on_money_changed(MoneyManager.money) 

func _on_money_changed(new_amount: int) -> void:
	money_label.text = "Money: " + str(new_amount)
