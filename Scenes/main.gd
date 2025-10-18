extends Node2D

const stages=["res://Scenes/stages/stage_1.tscn","res://Scenes/stages/stage_2.tscn"]
var stageNum:=0
@onready var stage:=$"Stage1"
var playerAnimationProgress:=0.0
var playerAnimationStartPos:Vector2

func loadStage(stagePath:String):
	stage.queue_free()
	stage=load(stagePath).instantiate()
	stage.z_index=-1
	add_child(stage)
	$Player.animating=true
	$"Player/Ring Timer".stop()
	playerAnimationProgress=0.0
	playerAnimationStartPos=$Player.position

func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
	$"VBoxContainer/Time Left".text=formatTime(stage.get_node("Time Left").time_left)
	%Reward.text="+"+str(stage.get_reward())
	if $Player.animating:
		playerAnimationProgress+=delta
		if playerAnimationProgress>=1:
			$Player.animating=false
			$Player.position=stage.get_node("Player Start Pos").global_position
			stage.get_node("Time Left").start()
			$"Player/Ring Timer".start()
		else:
			$Player.position=playerAnimationStartPos.lerp(stage.get_node("Player Start Pos").global_position,playerAnimationProgress)

func collectedTresure(tresure:Area2D):
	tresure.queue_free()
	if len(stage.getTresures())<=1:
		print('stage finished')
		stageNum+=1
		loadStage(stages[stageNum])
