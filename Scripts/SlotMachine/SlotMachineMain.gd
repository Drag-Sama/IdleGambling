extends Node

var reels: Array[Reel] = []
const DIR_SYMBOLS = "res://Assets/Sprite/SlotMachine/Machine/Reels/"

var current_result : Array[Texture2D] = []
const BASE_BET_VALUE := 1
var bet_value := BASE_BET_VALUE

var weight_symbols := {
	"7": 30,
	"10": 10,
	"dollar": 50
}

var paytable := {
	"7": 7,
	"10": 10,
	"dollar": 5
}

var reels_finished := 0
var lever_ready := true # pour pas pouvoir spam le levier (ça décale les reels vers le bas sinon puis ça sert à rien)

############ GETTERS ############

func get_symbol_name(texture: Texture2D) -> String:
	return texture.resource_path.get_file().get_basename()

func get_texture_symbol(symbol: String) -> Texture2D :
	var path = DIR_SYMBOLS + symbol + ".png"
	return load(path)

func get_random_symbol_by_weight() -> String :
	var total_weight := 0
	for weight in weight_symbols.values() :
		total_weight += weight
	var draw := randi_range(0,total_weight - 1)
	var sum := 0
	for symbol in weight_symbols.keys():
		sum += weight_symbols[symbol]
		if draw < sum :
			return symbol
	return ""

func get_random_texture_symbol_by_weight() -> Texture2D :
	return get_texture_symbol(get_random_symbol_by_weight())

################################

func calculate_gain(results: Array[Texture2D], value: int) -> int :
	var names = results.map(get_symbol_name)
	#count occurences of each symbols
	var count := {}
	for name in names :
		count[name] = count.get(name,0) + 1 # ici, .get(_,0) défini 0 en valeur par défaut, ce qui évite de vérifier si il y a déjà cet élt dans le dict
	# find the most frequent symbol and his occurences
	var best_name := ""
	var best_count := 0
	for name in count.keys():
		if count[name] > best_count :
			best_count = count[name]
			best_name = name
	var gain := 0
	if best_count == 2 :
		gain = value * paytable.get(best_name,0) / 2
	elif best_count == 3 :
		gain = value * paytable.get(best_name,0)
	print("Gain: ", gain, " (", best_count, "x ", best_name, "| base value = ", value, ")")
	return gain

func draw_result() -> Array[Texture2D] :
	var results: Array[Texture2D] = []
	for r in reels :
		results.append(get_random_texture_symbol_by_weight())
	return results

func _on_lever_button_pressed() -> void:
	if not lever_ready :
		print("arrt de spam sale chien")
		return
	lever_ready = false
	reels_finished = 0
	$Lever.play()
	#for reel in reels : # tirage
		#reel.remplir_symbols()
	current_result = draw_result()
	for i in reels.size() : # puis spin
		reels[i].spin(current_result[i])

func _on_reel_spin_finished() -> void:
	reels_finished += 1
	if reels_finished == reels.size():
		lever_ready = true
		# TODO calculer gain
		MoneyManager.updateMoney(calculate_gain(current_result,bet_value))
	return

func _on_lever_animation_finished() -> void:
	$Lever.frame = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Reel:
			reels.append(child)
			child.get_next_symbol = get_random_texture_symbol_by_weight
			child.spin_finished.connect(_on_reel_spin_finished)
	UpgradeManager.upgrade_bought.connect(_on_upgrade_bought)
	_update_bet()

######### UPGRADES PART ###########

func _on_upgrade_bought(_id: String) -> void:
	_update_bet()

func _update_bet() -> void:
	bet_value = BASE_BET_VALUE + UpgradeManager.get_bonus("bet_value")
