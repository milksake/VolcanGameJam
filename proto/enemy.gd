class_name Enemy
extends CharacterBody3D

@export_range(0, 100, 0.01)
var health : float = 100

@export
var contact_damage : float = 10
@export
var model : Node3D

var time := 0.0
var start_position : Vector3
var hover_height := 0.5
var hover_speed := 2.5

signal died

var rate : float = 0

func _ready() -> void:
	start_position = model.position

func _process(delta: float) -> void:
	health -= rate * delta
	if (health <= 0):
		emit_signal("died")
		call_deferred("queue_free")
	
	if model:
		time += delta
		model.position.y = start_position.y + sin(time * hover_speed) * hover_height

func damage(r : float):
	rate = r

func stop_damage():
	rate = 0.0
