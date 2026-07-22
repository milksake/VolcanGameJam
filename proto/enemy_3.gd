extends Enemy

@export var move_speed: float = 5.0
@export var attack_speed : float = 30.0
@export var attack_rate : float = 3.0
@export var attack_distance : float = 1000
@export var player : Player

var moving : bool = false
var repeat := 0

func _ready() -> void:
	super._ready()
	change_state()

func _physics_process(_delta: float) -> void:
	if moving:
		var mod = player.position
		mod.y = 2
		look_at(mod)
		var pos := (player.position - position)
		pos.y = 0
		velocity = move_speed * pos.normalized()
	else:
		repeat -= 1
		if not repeat:
			change_state()
	move_and_slide()

func change_state():
	if moving:
		moving = false
		var direction := (player.position - position)
		direction.y = 0
		direction = direction.normalized()
		var target_position := direction * attack_distance
		var mod = player.position
		mod.y = 2
		look_at(mod)
		velocity = direction * attack_speed
		@warning_ignore("narrowing_conversion")
		repeat = ((target_position.distance_to(position)-1) / attack_speed) + 1
	
	else:
		moving = true
		if is_inside_tree():
			get_tree().create_timer(attack_rate).connect("timeout", change_state)
