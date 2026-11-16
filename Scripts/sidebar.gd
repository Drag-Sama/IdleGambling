extends PanelContainer

@export var upgrades: Array[UpgradeData]
@export var ticket_list: Control    # le VBoxContainer dans le FoldableContainer Tickets
@export var slot_list: Control       # pour Slot-Machine
@export var tooltip: Control

var upgrade_button_scene = preload("res://Object/UpgradeButton.tscn")

func _ready() -> void:
	for upg in upgrades:
		var btn = upgrade_button_scene.instantiate()
		btn.setup(upg)
		btn.hovered.connect(tooltip.show_for)
		btn.unhovered.connect(tooltip.hide)
		match upg.machine:
			"ticket": ticket_list.add_child(btn)
			"slot": slot_list.add_child(btn)
