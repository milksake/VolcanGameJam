extends CharacterBody3D

var damage : float

func die():
	call_deferred("queue_free")

func _ready() -> void:
	get_tree().create_timer(10).connect("timeout", die)

func initialize(v : Vector3, d : float):
	velocity = v
	damage = d

func _process(delta: float) -> void:
	var coll = move_and_collide(velocity * delta)
	if coll:
		for i in range(coll.get_collision_count()):
			if coll.get_collider(i) is Player:
				coll.get_collider(i).damage(damage)
			die()
