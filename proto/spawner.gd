extends Node3D

@export var rate : float = 0.2
@export var max : int = 50
@export var frequency : Array[float]  = [1, 1, 1]
@export var player : Player

var rng = RandomNumberGenerator.new()

var enemies : Array[PackedScene] = [
	preload("res://proto/enemy1.tscn"),
	preload("res://proto/enemy2.tscn"),
	preload("res://proto/enemy3.tscn")
]

func _ready() -> void:
	var sum := frequency[0] + frequency[1] + frequency[2]
	for i in range(3):
		frequency[i] /= sum
	spawn()

func spawn():
	var index = rng.rand_weighted(frequency)
	var e = enemies[index].instantiate()
	e.position = position
	e.player = player
	get_parent().add_child(e)
	#get_parent().call_deferred("add_child", e)
	max -= 1
	
	if max:
		get_tree().create_timer(rate).connect("timeout", spawn)
	else:
		call_deferred("queue_free")
