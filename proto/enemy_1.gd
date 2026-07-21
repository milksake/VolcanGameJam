extends Enemy

@export var move_speed: float = 5.0
@export var player : Player

func _physics_process(_delta: float) -> void:
	look_at(player.position)
	velocity = move_speed * (player.position - position).normalized()
	move_and_slide()
