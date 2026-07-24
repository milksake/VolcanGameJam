extends CharacterBody3D

var damage : float
var vel : Vector3

var ex : PackedScene = preload("res://assets/BinbunVFX_Vol2/ExplosionFX/effects/air/vfx_air_explosion_01.tscn")

var dying : bool = false

@onready var b = $Node3D

func die():
	call_deferred("queue_free")

func _ready() -> void:
	get_tree().create_timer(10).connect("timeout", die)

func initialize(v : Vector3, d : float):
	vel = v
	damage = d

func _process(delta: float) -> void:
	if dying:
		return
	var coll = move_and_collide(vel * delta)
	if coll:
		for i in range(coll.get_collision_count()):
			if coll.get_collider(i) is Player:
				coll.get_collider(i).damage(damage)
		
		dying = true
		var e = ex.instantiate()
		add_child(e)
		b.visible = false
		$AudioStreamPlayer3D.play()
		
		get_tree().create_timer(2).connect("timeout", die)
