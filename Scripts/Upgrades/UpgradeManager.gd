extends Node

signal upgrade_bought(id: String)

var levels := {} # id -> niv actuel
var upgrades := {} # id -> UpgradeData

func register(upg: UpgradeData) -> void :  # setup upgrades in previous global var
	upgrades[upg.id] = upg
	if not levels.has(upg.id) :
		levels[upg.id] = 0

########## GETTERS ############

func get_level(id: String) -> int :
	return levels.get(id,0)
	
func get_cost(upg: UpgradeData) -> float :
	return upg.base_cost * pow(upg.cost_growth,get_level(upg.id))
	
func is_maxed(upg: UpgradeData) -> bool :
	return upg.max_level > 0 && get_level(upg.id) >= upg.max_level

###############################

func buy(upg: UpgradeData) -> bool :
	if is_maxed(upg) :
		return false
	if not MoneyManager.try_spend(get_cost(upg)):
		return false
	levels[upg.id] = get_level(upg.id) + 1
	upgrade_bought.emit(upg.id)
	return true

func get_bonus(effect_id: String) -> float : # renvoie la somme des effets de toutes les upgrades qui ciblent cet effet
	var total := 0
	for upg in upgrades.values():
		if upg.effect_id == effect_id :
			total += upg.value_per_level * get_level(upg.id)
	return total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
