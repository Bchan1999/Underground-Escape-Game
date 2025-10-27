extends Node2D

@export var tile : TileMapLayer

func _ready():
	print(tile.get_used_cells())
	pass
