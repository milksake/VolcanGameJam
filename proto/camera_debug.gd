extends Node2D

@onready var camera_rig = $".."

func pixel_to_rate(value: int) -> int:
	var wp_size = get_viewport().size
	return value * 100 / wp_size.x

func rate_to_pixel(value: int) -> int:
	var wp_size = get_viewport().size
	return wp_size.x * value / 100


func _draw():
	if not camera_rig:
		push_warning("Missing camera")
		return
		
	var wp_size = get_viewport().size
	var screen_center = wp_size / 2

	var near_size = rate_to_pixel(camera_rig.near_radius)
	draw_circle(screen_center, near_size, Color.RED, false)

	var far_size = rate_to_pixel(camera_rig.far_radius)
	draw_circle(screen_center, far_size, Color.RED, false)

@warning_ignore("unused_parameter")
func _process(delta):
	queue_redraw()
