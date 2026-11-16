class_name UpgradeData
extends Resource

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var machine: String = "ticket"   # "ticket" ou "slot"
@export var base_cost: float = 10.0
@export var cost_growth: float = 1.15
@export var max_level: int = 0            # 0 = illimité
@export var effect_id: String = ""        # ex : "ticket_value"
@export var value_per_level: float = 1.0
