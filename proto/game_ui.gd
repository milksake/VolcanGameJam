extends Control

@onready var progress : ProgressBar = $MarginContainer/Panel/MarginContainer/HBoxContainer/ProgressBar
@onready var rich : RichTextLabel = $MarginContainer2/PanelContainer/MarginContainer/RichTextLabel
@onready var box : Control = $MarginContainer2
@onready
var fill = progress.get_theme_stylebox("fill")

func change_energy(amount : float):
	if amount <= 25:
		fill.bg_color = Color.BROWN
	elif amount <= 50:
		fill.bg_color = Color("b79b2b")
	else:
		fill.bg_color = Color.LIME_GREEN
	progress.value = amount

func displayText(txt : String, secs : int):
	box.visible = true
	rich.text = txt
	get_tree().create_timer(secs).connect("timeout", deactivateText)

func deactivateText():
	box.visible = false
