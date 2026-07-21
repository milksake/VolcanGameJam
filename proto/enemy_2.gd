extends Enemy

@export var move_speed: float = 5.0
@export var attack_rate : float = 2.0
@export var cooldown_rate : float = 2.0
@export var player : Player
@export var proyectile_speed : float = 7.5
@export var proyectile_damage : float = 5.0

var bullet_scene : PackedScene = preload("res://proto/bullet.tscn")

var moving : bool = false

func _ready() -> void:
	change_state()

func _physics_process(_delta: float) -> void:
	if moving:
		look_at(player.position)
		velocity = move_speed * (player.position - position).normalized()
		move_and_slide()

func change_state():
	if moving:
		moving = false
		
		var b = bullet_scene.instantiate()
		b.initialize(proyectile_speed * (player.position - position), proyectile_damage)
		add_child(b)
		
		get_tree().create_timer(cooldown_rate).connect("timeout", change_state)
	
	else:
		moving = true
		get_tree().create_timer(attack_rate).connect("timeout", change_state)
