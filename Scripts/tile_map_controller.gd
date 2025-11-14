extends Node2D
class_name TileMapController

@export_category("Tile Maps")
@export var select_tile_map : TileMapLayer
@export var rock_map : TileMapLayer
@export var ground_map : TileMapLayer

@export_category("Entities")
@export var player : CharacterBody2D
@export var enemy : CharacterBody2D

var MAIN_SOURCE = 1
var SELECT_TILE = Vector2i(4,2)

var previousCell = Vector2i(4,2)

var clickable 
var can_click = false
var clickable_pos = []
var mouse_is_not_on_tile = true

var mouse_pos

var pathfinding = []

func _ready() -> void:
	if Debug.debugging:
		print("READY START: TileMapController")
		
	get_pathfinding(enemy.position, player.position)
	SignalBus.rock_tile_destroyed.connect(remove_tile)
	
	if Debug.debugging:
		print("READY END: TileMapController")
		
func get_pathfinding(start_pos, goal_pos):
	var enemy_on_map = convert_ground_map_coords(start_pos)
	
	var used_cells = ground_map.get_used_cells()
	
	var neighbor_cells = ground_map.get_surrounding_cells(enemy_on_map)
	
	var rock_cells = rock_map.get_used_cells();
	
	var rock_dict = {}
	for q in rock_cells:
		rock_dict[q] = "blocked"
	
	var dict = {}
	for x in used_cells: 
		if x not in rock_dict:
			dict[x] = "free"
		else:
			dict[x] = "blocked"
	
	var traveled_to = []
	var linkedPath = {}
	var num = 0
	
	var current_tile_check = 0
	var pre_cell = enemy_on_map

	traveled_to.append(enemy_on_map)
	while num < dict.size():
		#checks the first neihbor cells of enemy
		for y in neighbor_cells:
			if dict.get(y) && dict.get(y) != "blocked":
				if y not in traveled_to:
					traveled_to.append(y)
					linkedPath[y] = pre_cell
				
		current_tile_check += 1
		
		if current_tile_check < traveled_to.size():
			neighbor_cells = ground_map.get_surrounding_cells(traveled_to[current_tile_check])
			pre_cell = traveled_to[current_tile_check]
			
		num += 1
		
	var player_on_map = convert_ground_map_coords(goal_pos)
	
	var goal = player_on_map

	var g = 0
	while g < linkedPath.size():
		if linkedPath.get(goal) == null:
			break
		pathfinding.append(linkedPath.get(goal))
		goal = linkedPath.get(goal)
		g += 1
		
	pathfinding.reverse()
	return pathfinding
	
	
func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	var local_pos = select_tile_map.to_local(camera.get_global_mouse_position())
	mouse_pos = select_tile_map.local_to_map(local_pos)

	if clickable:
		for x in clickable:
			if (mouse_pos == x):
				GameSingleton.set_can_click(true)
				if (previousCell == mouse_pos):
					select_tile_map.set_cell(previousCell, MAIN_SOURCE, SELECT_TILE)
					#print("PREVIOUS CELL" , previousCell)
				else:
					select_tile_map.set_cell(mouse_pos, MAIN_SOURCE, SELECT_TILE)
					select_tile_map.erase_cell(previousCell)
					previousCell = mouse_pos
				mouse_is_not_on_tile = false
			
		if (mouse_is_not_on_tile == true): 
			GameSingleton.set_can_click(false)
		
	mouse_is_not_on_tile = true
	

func _on_player_moved_pos() -> void:
	if (previousCell):
		select_tile_map.erase_cell(previousCell)
	clickable_pos = []
	#var player_pos = select_tile_map.to_local(player.global_position)
	#var player_pos_map = select_tile_map.local_to_map(player_pos)
	var player_pos_map = convert_ground_map_coords(player.global_position)
	clickable = select_tile_map.get_surrounding_cells(player_pos_map)
	for item in clickable:
		clickable_pos.append(select_tile_map.local_to_map(item))
		
func convert_ground_map_coords(old_coords: Vector2) -> Vector2i:
	var player_pos_local = ground_map.to_local(old_coords)
	var player_on_map = ground_map.local_to_map(player_pos_local)
	return player_on_map
	
func convert_rock_map_coords(old_coords: Vector2) -> Vector2i:
	var player_pos_local = rock_map.to_local(old_coords)
	var player_on_map = rock_map.local_to_map(player_pos_local)
	return player_on_map

func remove_tile(entity : Node2D):
	var tile_coords = convert_rock_map_coords(entity.global_position)
	#print(rock_map.get_used_cells())
	#print("TILE COORDS", tile_coords)
	#print("BEFORE!!")
	rock_map.erase_cell(tile_coords)
	#print(rock_map.get_used_cells())
	#print("AFTER!!")
	#
	#
	#print(entity)
	
