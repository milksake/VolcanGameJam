class_name Player
extends CharacterBody3D

@export var energy : float = 100
@export var invulnerability : float = 2

@export var move_speed: float = 5.0
@export var ease_speed: float = 5.0
@export_range(0, 100, 0.01)
var strength : float = 50.0
@onready var camera_rig : CameraRig = $CameraRig as CameraRig
@onready var flash = $Flashlight

@export var ui : Control

@export var energy_loosing_rate : float = 2

var can_be_damaged = true

func _ready() -> void:
	ui.call_deferred("change_energy", energy)
	#ui.change_energy(energy)

func reset():
	can_be_damaged = true

func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_rotation(delta)
	_handle_clicking()

func _process(delta: float) -> void:
	energy -= energy_loosing_rate * delta
	ui.change_energy(energy)

func get_input_direction() -> Vector3:
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("m_up"):
		input_dir.z -= 1
	if Input.is_action_pressed("m_down"):
		input_dir.z += 1
	if Input.is_action_pressed("m_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("m_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()
	return input_dir

# Keys
func _handle_movement() -> void:
	var input_dir = get_input_direction()
	var velocity_vector = input_dir * move_speed
	velocity.x = velocity_vector.x
	velocity.z = velocity_vector.z
	if move_and_slide():
		var c : KinematicCollision3D = get_last_slide_collision()
		for i in range(c.get_collision_count()):
			if (c.get_collider(i) is Enemy):
				damage(c.get_collider(i).contact_damage)

# Mouse
func _handle_rotation(delta: float) -> void:
	if not camera_rig:
		printerr("Missing camera")
		return
	
	var camera: Camera3D = camera_rig.camera
	var viewport = get_viewport();
	if not viewport:
		printerr("Missing viewport")
		return
		
	var mouse_pos = viewport.get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)
	var plane = Plane(Vector3.UP, position.y)
	var mouse_world_pos = plane.intersects_ray(from, dir)

	if mouse_world_pos != null:
		var target_dir = (position - mouse_world_pos).normalized()
		var target_rot_y = atan2(target_dir.x, target_dir.z)
		var current_rot_y = rotation.y
		rotation.y = lerp_angle(current_rot_y, target_rot_y, 1.0 - pow(0.001, delta * ease_speed))


func _handle_clicking():
	if Input.is_action_pressed("click"):
		flash.visible = true
		#for shape in $Collision.get_children():
			#if shape is CollisionShape3D:
				#shape.disabled = true
	else:
		flash.visible = false
	pass

# Damage
func _on_flashlight_body_entered(body: Node3D) -> void:
	if body.has_method("damage"):
		body.damage(strength)

func _on_flashlight_body_exited(body: Node3D) -> void:
	if body.has_method("stop_damage"):
		body.stop_damage()

func damage(amount : float):
	if can_be_damaged:
		energy -= amount
		can_be_damaged = false
		get_tree().create_timer(invulnerability).connect("timeout", reset)
		ui.change_energy(energy)
