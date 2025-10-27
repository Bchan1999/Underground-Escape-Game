extends Node
@onready var draw_arrow: TileMapLayer = $Draw_Arrow

@export var tilemap: TileMapLayer
@export var camera: Camera2D
@export var player : CharacterBody2D

var right_click_state = false
var clicked = false

var MAIN_SOURCE = 2
var GREEN_TILE = Vector2i(7,0)
var BLUE_UP_ARROW = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#var new_layer = ARROW.instantiate()
	#add_child(new_layer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_check()
	
func input_check():
	if right_click_state != false:
		var local_pos = tilemap.to_local(camera.get_global_mouse_position())
		var clicked_cell = tilemap.local_to_map(local_pos)
		var player_pos = tilemap.local_to_map(tilemap.to_local(player.position))
		#print(clicked_cell)
		print(player_pos)
		if (player_pos == clicked_cell):
			clicked = true
			
		if (clicked == true):
			get_clicked_tile_power()
		
		
		
		#var camera = get_viewport().get_camera_2d()
		##print(camera.get_global_mouse_position())
		#print(tilemap.to_local(camera.get_global_mouse_position()))
		###tilemap.map_to_local()
		
func get_clicked_tile_power():
	var camera = get_viewport().get_camera_2d()
	var local_pos = tilemap.to_local(camera.get_global_mouse_position())
	var clicked_cell = tilemap.local_to_map(local_pos)
	#tilemap.erase_cell(clicked_cell)	
	draw_arrow.set_cell(clicked_cell, MAIN_SOURCE, BLUE_UP_ARROW)
	#player.position = clicked_cells
	
func clear_tile():
	draw_arrow.clear()
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("right_click"):
		right_click_state = true
	if event is InputEventMouseButton and event.is_action_released("right_click"):
		clear_tile()
		clicked = false
		right_click_state = false
