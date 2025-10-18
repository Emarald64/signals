extends Node2D

const stages=["res://Scenes/stages/stage_1.tscn","res://Scenes/stages/stage_2.tscn","res://Scenes/stages/stage_3.tscn"]
var stageNum:=0
@onready var stage:Stage
var playerAnimationProgress:=0.0
var playerAnimationStartPos:Vector2

func _ready() -> void:
	loadStage(stages[0],true)

func loadStage(stagePath:String,firstStage:=false) -> void:
	# replace old stage with new one
	if not firstStage:stage.queue_free()
	stage=load(stagePath).instantiate()
	stage.z_index=-1
	stage.get_node("Time Left").timeout.connect(timeUp)
	call_deferred("add_child",stage)
	
	#Set camera limits
	$Camera2D.limit_left=stage.cameraLimits.position.x
	$Camera2D.limit_top=stage.cameraLimits.position.y
	$Camera2D.limit_right=stage.cameraLimits.end.x
	$Camera2D.limit_bottom=stage.cameraLimits.end.y
	
	# Start player animation
	if not firstStage:
		$Player.animating=true
		$"Player/Ring Timer".stop()
		playerAnimationProgress=0.0
		playerAnimationStartPos=$Player.position

static func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)%60).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
	%"Time Left".text=formatTime(stage.get_node("Time Left").time_left)
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
	tresure.found()
	$Camera2D.add_trauma(0.3)
	if len(stage.getTresures())<=1:
		print('stage finished')
		stageNum+=1
		loadStage(stages[stageNum])

func timeUp():
	print('out of time')
