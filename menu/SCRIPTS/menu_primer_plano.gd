extends Control


func _on_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://proto/view.tscn")

func _on_ajustes_pressed() -> void:
	$PanelAjustes.visible = true

func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_volver_pressed() -> void:
	$PanelAjustes.visible = false


func _on_creditos_pressed() -> void:
	$PanelCreditos.visible = true


func _on_boton_volver_1_pressed() -> void:
	$PanelCreditos.visible = false


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ESCENA/menu_primer_plano.tscn")
