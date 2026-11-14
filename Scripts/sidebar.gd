extends PanelContainer

@export var upgrades: Array[UpgradeData]
@export var tickets_list: Control    # le VBoxContainer dans le FoldableContainer Tickets
@export var slot_list: Control       # idem pour Slot-Machine

var upgrade_button_scene = preload("res://Object/UpgradeButton.tscn")  # adapte le chemin

func _ready() -> void:
	for upg in upgrades:
		var btn = upgrade_button_scene.instantiate()
		btn.setup(upg)
		match upg.machine:
			"tickets": tickets_list.add_child(btn)
			"slot": slot_list.add_child(btn)
