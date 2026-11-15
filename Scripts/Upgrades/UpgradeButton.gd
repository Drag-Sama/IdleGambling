extends Button

var upg: UpgradeData

signal hovered(upg: UpgradeData,button: Control)
signal unhovered

func setup(u: UpgradeData) -> void :
	upg = u
	UpgradeManager.register(u)
	_refresh()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	UpgradeManager.upgrade_bought.connect(_on_upgrade_bought)
	MoneyManager.money_changed.connect(_on_money_changed)
	mouse_entered.connect(func(): hovered.emit(upg, self))
	mouse_exited.connect(func(): unhovered.emit())

func _on_pressed() -> void :
	UpgradeManager.buy(upg)

func _on_upgrade_bought(_id: String) -> void :
	_refresh()

func _on_money_changed(_value) -> void :
	_refresh()

func _refresh() -> void :
	var level = UpgradeManager.get_level(upg.id)
	if UpgradeManager.is_maxed(upg) :
		text = "%s  (Nv. %d)\nMAX" % [upg.display_name, level]
		disabled = true
	else :
		var cost = UpgradeManager.get_cost(upg)
		text = "%s  (Nv. %d)\n%d $" % [upg.display_name, level, cost]
		disabled = MoneyManager.money < cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
