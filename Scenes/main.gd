extends Node2D

const stages=["res://Scenes/stages/stage_1.tscn","res://Scenes/stages/stage_2.tscn","res://Scenes/stages/shop.tscn","res://Scenes/stages/stage_3.tscn","res://Scenes/stages/stage_4.tscn"]
var stageNum:=-1
@export var stage:CanvasItem
var playerAnimationProgress:=0.0
var playerAnimationStartPos:Vector2
var totalStageTresures:=0
var money:=0
var showUI:=true

#func _ready() -> void:
	#loadStage(stages[0],true)

func loadNextStage() -> void:
	print('laoading next stage')
	stageNum+=1
	loadStage(stages[stageNum])

func loadStage(stagePath:String,firstStage:=false) -> void:
	# replace old stage with new one
	if not firstStage:stage.queue_free()
	stage=load(stagePath).instantiate()
	call_deferred("add_child",stage)
	
	if stage is TresureStage:
		%"Stage Counter".text="Stage: "+str(stageNum+1)
		totalStageTresures=len(stage.getTresures())
		%"Tresure Counter".text="Tresures: 0/"+str(totalStageTresures)
		stage.z_index=-1
		stage.get_node("Time Left").timeout.connect(timeUp)
		#Set camera limits
		$Camera2D.limit_left=stage.cameraLimits.position.x
		$Camera2D.limit_top=stage.cameraLimits.position.y
		$Camera2D.limit_right=stage.cameraLimits.end.x
		$Camera2D.limit_bottom=stage.cameraLimits.end.y
		
		$CanvasLayer.show()
	
		# Start player animation
		if not firstStage:
			$Player.animating=true
			$"Player/Ring Timer".stop()
			playerAnimationProgress=0.0
			playerAnimationStartPos=$Player.position
	else:
		$"Player/Ring Timer".stop()
		$CanvasLayer.hide()
		$Camera2D.limit_left=0
		$Camera2D.limit_top=0
		$Camera2D.limit_right=1280
		$Camera2D.limit_bottom=720

static func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)%60).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_1"):
		if stage is Stage:
			loadNextStage()
		else:money+=100
		
	
	if stage is TresureStage:
		%"Time Left".text=formatTime(stage.get_node("Time Left").time_left)
		%Reward.text="+"+str(stage.get_reward())
	if $Player.animating and stage is TresureStage:
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
	print(len(stage.getTresures()))
	%"Tresure Counter".text="Tresures: "+str(totalStageTresures-len(stage.getTresures()))+"/"+str(totalStageTresures)
	if len(stage.getTresures())==0:
		print('stage finished')
		money+=stage.get_reward()
		%Money.text=str(money)
		loadNextStage()

func timeUp():
	add_child(preload("res://Scenes/game_over.tscn").instantiate())
