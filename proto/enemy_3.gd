extends Enemy

@export var move_speed: float = 5.0
@export var attack_speed : float = 30.0
@export var attack_rate : float = 3.0
@export var attack_distance : float = 1000
@export var player : Player

var moving : bool = false
var repeat := 0

func _ready() -> void:
	change_state()

func _physics_process(_delta: float) -> void:
	if moving:
		look_at(player.position)
		velocity = move_speed * (player.position - position).normalized()
	else:
		repeat -= 1
		if not repeat:
			change_state()
	move_and_slide()

func change_state():
	if moving:
		moving = false
		var direction := (player.position - position).normalized()
		var target_position := direction * attack_distance
		look_at(player.position)
		velocity = direction * attack_speed
		@warning_ignore("narrowing_conversion")
		repeat = ((target_position.distance_to(position)-1) / attack_speed) + 1
	
	else:
		moving = true
		get_tree().create_timer(attack_rate).connect("timeout", change_state)
