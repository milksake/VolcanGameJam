extends Enemy

@export var move_speed: float = 5.0
@export var attack_rate : float = 2.0
@export var cooldown_rate : float = 2.0
@export var player : Player
@export var proyectile_speed : float = 15
@export var proyectile_damage : float = 5.0

@onready var gun_position = $Gun

var bullet_scene : PackedScene = preload("res://proto/bullet.tscn")

var moving : bool = false

func _ready() -> void:
	change_state()

func _physics_process(_delta: float) -> void:
	if moving:
		var mod = player.position
		mod.y = 2
		look_at(mod)
		var pos := (player.position - position)
		pos.y = 0
		velocity = move_speed * pos.normalized()
		move_and_slide()

func change_state():
	if moving:
		moving = false
		
		var b = bullet_scene.instantiate()
		var pos : Vector3 = (player.position - gun_position.global_position)
		pos.y = 0
		b.initialize(proyectile_speed * pos.normalized(), proyectile_damage)
		var mod = player.position
		mod.y = 2
		b.look_at_from_position(gun_position.global_position, mod)
		get_parent().add_child(b)
		
		if is_inside_tree():
			get_tree().create_timer(cooldown_rate).connect("timeout", change_state)
	
	else:
		moving = true
		if is_inside_tree():
			get_tree().create_timer(attack_rate).connect("timeout", change_state)
