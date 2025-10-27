extends Node2D
class_name States

signal Transitioned

#called when the machine transtions to this state
func enter():
	pass
	
#called when state ends
func exit():
	pass
	
func update(_delta: float):
	pass
	
func physics_update(_delta: float):
	pass

func get_state_name() -> String:
	push_error("Method get_state_name() must be defined")
	return ""
