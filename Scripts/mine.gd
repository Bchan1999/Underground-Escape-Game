extends States
class_name PlayerMine

@export var anim : AnimationPlayer
	
func enter():
	anim.play("mine")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !anim.is_playing():
		print("not playing")
		Transitioned.emit(self, "Idle")
		
