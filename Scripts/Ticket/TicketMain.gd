extends PanelContainer

var ticket = preload("res://Object/Ticket.tscn")

func _on_buy_button_pressed() -> void: #Quand on appuit sur le bouton Buy
	MoneyManager.updateMoney(-2)
	var ticket_instance = ticket.instantiate()
	
	var horizontal_position = randf_range(150.0, size.x - 150) #Résolu ? Faudrait modifier les valeurs pour que ça s'adapte à la taille de l'écran mais jsp comment faire
	
	ticket_instance.position = Vector2(horizontal_position, 0)
	ticket_instance.scale = Vector2(0.2, 0.2)
	add_child(ticket_instance)

	var distance = randf_range(100.0, 300.0)
	var target_position = ticket_instance.position + Vector2(0, distance)

	# Rotation aléatoire 
	var rotation_amount = randf_range(-PI/10, PI/10)  

	# Animation
	var duration = randf_range(0.4, 0.8)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)  # permet aux deux animations de se jouer en même temps

	tween.tween_property(ticket_instance, "position", target_position, duration)
	tween.tween_property(ticket_instance, "rotation", rotation_amount, duration)
