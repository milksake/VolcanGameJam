class_name Enemy
extends CharacterBody3D

@export_range(0, 100, 0.01)
var health : float = 100

@export
var contact_damage : float = 10

var rate : float = false

func _process(delta: float) -> void:
	health -= rate * delta
	if (health <= 0):
		call_deferred("queue_free")

func damage(r : float):
	rate = r

func stop_damage():
	rate = 0.0
