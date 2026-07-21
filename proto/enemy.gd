class_name Enemy
extends CharacterBody3D

@export var move_speed: float = 5.0
@export var player : Player
@export_range(0, 100, 0.01)
var health : float = 100

var rate : float = false

func _physics_process(_delta: float) -> void:
	look_at(player.position)
	velocity = move_speed * (player.position - position).normalized()
	move_and_slide()

func _process(delta: float) -> void:
	health -= rate * delta
	if (health <= 0):
		call_deferred("queue_free")

func damage(r : float):
	rate = r

func stop_damage():
	rate = 0.0
