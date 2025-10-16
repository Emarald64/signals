extends Node2D

func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
	$"VBoxContainer/Time Left".text=formatTime($"Time Left".time_left)

func getTresure() -> Node:
	return $Tresure
