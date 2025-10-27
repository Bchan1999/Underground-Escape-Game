extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var tile_size = 35.65

var animation_speed = 3
var moving = false

@export var sprite : AnimatedSprite2D
@export var anim : AnimationPlayer

signal moved_pos

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	if moving:
		return
	if event.is_action_pressed("left"):
		sprite.flip_h = true
	elif event.is_action_pressed("right"):
		sprite.flip_h = false
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
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
