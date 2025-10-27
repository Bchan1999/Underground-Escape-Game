extends States
class_name PlayerIdle

@export var anim : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	anim.play("idle")
	pass # Replace with function body


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mine"):
		GameSingleton.player_action.emit()
		Transitioned.emit(self, "Mine")
