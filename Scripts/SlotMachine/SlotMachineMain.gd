extends Node

var reels: Array[Reel] = []
const DIR_SYMBOLS = "res://Assets/Sprite/SlotMachine/Machine/Reels/"

var current_result : Array[Texture2D] = []
var current_value := 1

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
var lever_ready := true # pour pas pouvoir spam le levier (ça décale les reels vers le bas sinn puis ça sert à rien)

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
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Reel:
			reels.append(child)
			child.get_next_symbol = get_random_texture_symbol_by_weight
			child.spin_finished.connect(_on_reel_spin_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lever_animation_finished() -> void:
	$Lever.frame = 0
