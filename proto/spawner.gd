extends Node3D

@export var rate : float = 0.2
@export var maxx : int = 5
@export var frequency : Array[float]  = [1, 1, 1]
@export var player : Player
@export var enemy_node : Node
@export var level : Level

#signal finished

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

func activate():
	spawn()

func spawn():
	var index = rng.rand_weighted(frequency)
	var e = enemies[index].instantiate()
	e.position = position
	e.player = player
	e.connect("died", level.enemy_died)
	enemy_node.add_child(e)
	maxx -= 1
	
	if maxx:
		get_tree().create_timer(rate).connect("timeout", spawn)
	else:
		visible = false
		#await get_tree().create_timer(3).timeout
		#emit_signal("finished")
