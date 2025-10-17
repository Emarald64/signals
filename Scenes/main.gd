extends Node2D

@export var tresures:Array[Area2D]
@onready var stage:=$"Stage 1"

func loadStage(stagePath:String):
	$Player.animating=true

func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
	$"VBoxContainer/Time Left".text=formatTime(stage.get_node("Time Left").time_left)
	%Reward.text="+"+str(stage.get_reward())

func collectedTresure(tresure:Area2D) ->bool:
	tresures.erase(tresure)
	tresure.queue_free()
	return len(tresures)==0
