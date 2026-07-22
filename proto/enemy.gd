class_name Enemy
extends CharacterBody3D

var orb_scene = preload("res://assets/BinbunVFX_Vol2/DarkMagicFX/effects/ball/vfx_ball_evil_01.tscn")
@onready var orb = orb_scene.instantiate()

var explosion_scene = preload("res://assets/BinbunVFX_Vol2/ExplosionFX/effects/ground/vfx_ground_explosion_01.tscn")

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
var has_died = false

var rate : float = 0

func _ready() -> void:
	start_position = model.position
	orb.emitting = false
	orb.scale = Vector3.ONE * 0.2
	model.add_child(orb)

func _process(delta: float) -> void:
	if has_died:
		return
	health -= rate * delta
	if (health <= 0):
		emit_signal("died")
		has_died = true
		var ex = explosion_scene.instantiate()
		add_child(ex)
		ex.play()
		has_died = true
		model.visible = false
		await get_tree().create_timer(2).timeout
		call_deferred("queue_free")
	
	time += delta
	model.position.y = start_position.y + sin(time * hover_speed) * hover_height

func damage(r : float):
	if not orb.emitting:
		orb.emitting = true
	rate = r

func stop_damage():
	if orb.emitting:
		orb.emitting = false
	rate = 0.0
