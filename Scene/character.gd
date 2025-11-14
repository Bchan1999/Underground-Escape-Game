extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 10

@onready var health = MAX_HEALTH

var tile_size = 35.65

var animation_speed = 3
var moving = false

@export var sprite : AnimatedSprite2D
@export var anim : AnimationPlayer
@export var ray_cast_right : RayCast2D
@export var ray_cast_left : RayCast2D
@export var ray_cast_down : RayCast2D
@export var ray_cast_up : RayCast2D

signal moved_pos

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func _process(delta: float) -> void:
	$CanvasLayer/Label.text = str("Health: ", health , "/10")
	
	
func _unhandled_input(event):
	if moving:
		return
	if event.is_action_pressed("left"):
		sprite.flip_h = true
	elif event.is_action_pressed("right"):
		sprite.flip_h = false
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if !check_if_collision(dir):
				move(dir)	
			
func move(dir):
	var tween = create_tween()
	anim.play("run")
	tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
	moved_pos.emit()
	GameSingleton.player_action.emit()
	anim.play("idle")
	
func check_if_collision(dir):
	if Debug.player_debug:
		if dir == "left":
			print("left collide with" , ray_cast_left.get_collider())
		elif dir == "right":
			print("right collide with" , ray_cast_right.get_collider())
		elif dir == "up":
			print("up collide with" , ray_cast_up.get_collider())
		elif dir == "down":	
			print("down collide with" , ray_cast_down.get_collider())
	
	if dir == "left":
		return ray_cast_left.is_colliding()
	elif dir == "right":
		return ray_cast_right.is_colliding()
	elif dir == "up":
		return ray_cast_up.is_colliding()
	elif dir == "down":	
		return ray_cast_down.is_colliding()
	else:
		push_error("Not a valid direction")
		
	
		
func give_me_dmg(attacker, dmg):
	if Debug.player_debug:
		print("Player Class: Player takes ", dmg, " damage from ", attacker)
		
	health = health - dmg
