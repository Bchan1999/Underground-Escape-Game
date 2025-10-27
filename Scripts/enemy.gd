extends CharacterBody2D

var movement_speed = 2
@export var target : Node2D = null
@export var tile_map_controller : TileMapController
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
var tile_size = 35.65

var moving = false

var xdiff
var ydiff

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
			
var pathfinding
var starting

var x = 0

func _ready() -> void:
	pathfinding = tile_map_controller.get_pathfinding()
	starting = pathfinding[0]
	print("Enemy makes these moves", pathfinding)
	#call_deferred("enemy_setup")
	#GameSingleton.player_action.connect(calculate_move)

func enemy_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position
	
	move_and_slide()
	
#func calculate_move():
	#
	
func _process(delta: float) -> void:
	if !moving:
		var diff = pathfinding[x] - starting
		starting = pathfinding[x]
		print(diff)
		if (diff == Vector2i(1, 0)):
			move("right")
		elif (diff == Vector2i(-1, 0)):
			move("left")
		elif (diff == Vector2i(0, 1)):
			move("down")
		elif (diff == Vector2i(0, -1)):
			move("up")
			
		x += 1
	
			
		
		
		
	#if target:
		#navigation_agent_2d.target_position = target.global_position
	#if navigation_agent_2d.is_navigation_finished():
		#return
		#
	#var current_agent_pos = global_position
	#var next_path_pos = navigation_agent_2d.get_next_path_position()
	#
	#xdiff = next_path_pos.x - current_agent_pos.x
	#ydiff = next_path_pos.y - current_agent_pos.y
	#
	#var vectorDiff = next_path_pos - current_agent_pos
#
	#var x_direction = 1
	#var y_direction = 1
#
	#if (xdiff > 0):
		#x_direction = 1
	#elif (xdiff <= 0):
		#x_direction = -1
#
	#if (ydiff > 0):
		#y_direction = 1
	#elif (ydiff <= 0):
		#y_direction = -1
	#
	#print("Next Path Postion: " , next_path_pos)
	#print("Vector diff: ", vectorDiff)
		#
	#print("Enemy pos/Player pos X delta: " , xdiff, " x_direction: ", x_direction)
	#print("Enemy pos/Player pos Y delta: ", ydiff, " y_direction : ",  y_direction)
		#
	#if (abs(xdiff) > abs(ydiff) && x_direction == 1):
		#move("right")
	#elif (abs(xdiff) > abs(ydiff) && x_direction == -1):
		#move("left")
	#elif (abs(xdiff) < abs(ydiff) && y_direction == 1):
		#move("down")
	#elif (abs(xdiff) < abs(ydiff) && y_direction == -1):
		#move("up")
	
	
	
func move(dir):
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/movement_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished
	moving = false
	print("stopeed")
	
