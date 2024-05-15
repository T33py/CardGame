extends Area2D

signal hovered(area: Area2D, side: int)

# Convention will be right = 1, left = 2
@export var hover_side = 0


func _on_area_entered(area):
	hovered.emit(area, hover_side)
	pass # Replace with function body.
