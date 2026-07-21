class_name CameraRig
extends Node3D

@onready var offset_rig = $OffsetRig
@onready var camera = $OffsetRig/Camera3D
@onready var camera_debug = $CameraDebug

@export var player: Player
@export var enabled: bool = false
@export var enable_cursor_shift: bool = false

@export_group("Camera to cursor")
@export_range(0, 100)
var near_radius: int = 10
@export var near_shift = 0.5

@export_range(0, 100)
var far_radius: int = 30
@export var far_shift = 6.0

@export_group("Camera follow")
@export var follow_duration: float = 0.2

var _offset = Vector3.ZERO
var _tween: Tween
var _lookahead: Vector3 = Vector3.ZERO

func _calc_offset():
	if not player:
		printerr("No player")
		return	
	var offset_x = global_position.x - player.position.x
	var offset_z = global_position.z - player.position.z
	_offset = Vector3(offset_x, 0, offset_z)


func pixel_to_rate(value: int) -> int:
	var wp_size = get_viewport().size
	return value * 100 / wp_size.x

func rate_to_pixel(value: int) -> int:
	var wp_size = get_viewport().size
	return wp_size.x * value / 100


func _ready():
	_calc_offset()

func _physics_process(_delta):
	if not player || not enabled:
		return

	var base_pos := global_position
	base_pos.x = player.global_position.x + _offset.x
	base_pos.z = player.global_position.z + _offset.z
	base_pos.y = global_position.y
	
	var final_pos = base_pos
	if enable_cursor_shift:
		final_pos = base_pos + _lookahead
	
	global_position = final_pos
	
	var target_shift = _add_cursor_offset()
	calculate_lookahead(target_shift)

func calculate_lookahead(target: Vector3):
	if _lookahead.is_equal_approx(target):
		return

	if _tween and _tween.is_running():
		_tween.kill()
		
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "_lookahead", target, 0.5)

func _add_cursor_offset() -> Vector3:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var center_pos = viewport.get_visible_rect().size / 2

	var offset_vector = mouse_pos - center_pos
	var offset_rate = pixel_to_rate(round(offset_vector.length()))
	
	var shift = remap(offset_rate, near_radius, far_radius, near_shift, far_shift)

	var step_shift = step(shift, near_shift, far_shift) 
	var shift_vector = step_shift * offset_vector.normalized();
	return Vector3(shift_vector.x, 0, shift_vector.y)

func step(value, min_value, max_value):
	if value < min_value:
		return 0
	if value > max_value:
		return max_value
	return value
