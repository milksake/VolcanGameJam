class_name Level
extends Node3D

@onready var spawners = $Spawners
@onready var ui = $GameUI
@export var wait_time : float = 5
@export var events : Array[int]
@export_multiline() var text : Array[String]
@onready var enemy_node := $Enemies

var ind := 0
var curr := 0
var pending := 1
var t := 0

var enemies_remaining = 0

func enemy_died():
	print(enemies_remaining)
	enemies_remaining -= 1
	if not enemies_remaining:
		next_event()

func next_event():
	pending -= 1
	if pending:
		return
	
	#print(ind)
	if ind >= len(events):
		get_tree().change_scene_to_file("res://menu/ESCENA/menu_primer_plano.tscn")
		return
	
	await get_tree().create_timer(wait_time).timeout

	if events[ind] < 0:
		ui.displayText(text[t], -events[ind])
		get_tree().create_timer(-events[ind]).connect("timeout", next_event)
		pending = 1
		t += 1
	else:
		pending = events[ind]
		for i in range(events[ind]):
			#print("\t",curr)
			var s = spawners.get_child(curr)
			s.visible = true
			enemies_remaining = s.maxx
			s.activate()
			
			curr += 1
	
	ind += 1

func _ready() -> void:
	next_event()
