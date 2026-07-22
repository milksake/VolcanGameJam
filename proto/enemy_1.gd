extends Enemy

@export var move_speed: float = 5.0
@export var player : Player

func _physics_process(_delta: float) -> void:
	var mod = player.position
	mod.y = 2
	look_at(mod)
	var pos := (player.position - position)
	pos.y = 0
	velocity = move_speed * pos.normalized()
	move_and_slide()
