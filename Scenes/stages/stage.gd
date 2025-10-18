class_name Stage extends Node2D

@export var spareTime:=20
@export var maxReward:=100

func get_reward() -> int:
	return min(1,($"Time Left".time_left/($"Time Left".wait_time-spareTime)))*maxReward

func getTresures() -> Array[Area2D]:
	var out:Array[Area2D]=[]
	for child in get_children():
		if child.get_meta("tresure",false):
			out.append(child)
	return out
