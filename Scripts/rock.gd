extends Node2D

var MAX_HEALTH = 10
var health
@export var anim : AnimationPlayer

var isPlaying = false
var waitTillDeath = false

func _ready() -> void:
	health = MAX_HEALTH
	anim.play("whole")
	
func _process(delta: float) -> void:
	isPlaying = anim.is_playing()
	if(waitTillDeath == true && isPlaying == false):
		SignalBus.rock_tile_destroyed.emit(self)
		self.queue_free()

func give_me_dmg(dmg: int):
	health = health - dmg
	anim.play("damage")
	if health == 0:
		anim.play("break")
		waitTillDeath = true
		

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("mine")):
		if (GameSingleton.get_can_click() == true):
			print("rock is clicked on")
			give_me_dmg(5)
	
