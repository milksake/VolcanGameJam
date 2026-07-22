extends Control

@onready var progress : ProgressBar = $MarginContainer/Panel/MarginContainer/HBoxContainer/ProgressBar
@onready
var fill = progress.get_theme_stylebox("fill")

func change_energy(amount : float):
	if amount <= 50:
		fill.bg_color = Color("b79b2b")
	else:
		fill.bg_color = Color.LIME_GREEN
	progress.value = amount
