extends Node

var can_click = false

signal player_action

func get_can_click() -> bool:
	return can_click
	
func set_can_click(x):
	can_click = x
