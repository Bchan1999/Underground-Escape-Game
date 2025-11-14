extends CharacterBody2D
class_name BasicEnemy

var movement_speed = 2
var attack_dmg = 2
@export var target : Node2D = null
@export var tile_map_controller : TileMapController
@export var ray_cast_right : RayCast2D
@export var ray_cast_left : RayCast2D
@export var ray_cast_down : RayCast2D
@export var ray_cast_up : RayCast2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var tile_size = 35.65

var is_moving = false

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
	pathfinding = tile_map_controller.get_pathfinding(position, target.position)
	if pathfinding[0] != null:
		starting = pathfinding[0]
	else:
		push_error("Pathfinding is null")
		
	print("Enemy makes these moves", pathfinding)
	GameSingleton.player_action.connect(character_action_trigger)
		
func character_action_trigger():
	pathfinding = tile_map_controller.get_pathfinding(global_position, target.position)
	
	var diff = pathfinding[1] - starting
	starting = pathfinding[1]
	if (diff == Vector2i(1, 0)):
		move("right")
	elif (diff == Vector2i(-1, 0)):
		move("left")
	elif (diff == Vector2i(0, 1)):
		move("down")
	elif (diff == Vector2i(0, -1)):
		move("up")

	
func move(dir):
	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/movement_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished
	is_moving = false
	print("Move class called")
	check_player_adj()
	print("stopeed")
	
#Only checks after enemy is done is_moving
func check_player_adj():
	var right_check : Object = ray_cast_right.get_collider()
	var left_check : Object = ray_cast_left.get_collider()
	var down_check : Object = ray_cast_down.get_collider()
	var up_check : Object = ray_cast_up.get_collider()
	
	if right_check != null:
		print(right_check.get_class())
		if right_check.get_class() == "CharacterBody2D":
			attack_entity(right_check)
	elif left_check != null:
		if left_check.get_class() == "CharacterBody2D":
			attack_entity(left_check)
	elif down_check != null:
		if down_check.get_class() == "CharacterBody2D":
			attack_entity(down_check)	
	elif up_check != null:
		if up_check.get_class() == "CharacterBody2D":
			attack_entity(up_check)
			
func attack_entity(entity):
	entity.give_me_dmg(self, attack_dmg)
	
