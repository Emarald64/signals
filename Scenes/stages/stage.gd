@tool
class_name Stage extends Node2D

@export var cameraLimits:Rect2i:
	set(new_value):
		cameraLimits=new_value
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(cameraLimits,Color.YELLOW,false,5)
