extends Node2D

const stages=["res://Scenes/stages/shop.tscn","res://Scenes/stages/stage_1.tscn","res://Scenes/stages/stage_2.tscn","res://Scenes/stages/stage_3.tscn"]
var stageNum:=0
@onready var stage:CanvasItem
var playerAnimationProgress:=0.0
var playerAnimationStartPos:Vector2
var money:=1000
var showUI:=true

func _ready() -> void:
	loadStage(stages[0],true)

func loadNextStage() -> void:
	stageNum+=1
	loadStage(stages[stageNum])

func loadStage(stagePath:String,firstStage:=false) -> void:
	# replace old stage with new one
	if not firstStage:stage.queue_free()
	stage=load(stagePath).instantiate()
	call_deferred("add_child",stage)
	
	if stage is TresureStage:
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

static func formatTime(time:float) -> String:
	return str(floori(time/60)).pad_zeros(1)+":"+str(floori(time)%60).pad_zeros(2)+"."+str(floori(time*100)%100).pad_zeros(2)

func _process(delta: float) -> void:
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
	if len(stage.getTresures())<=1:
		print('stage finished')
		money+=stage.get_reward()
		%Money.text=str(money)
		loadNextStage()

func timeUp():
	add_child(preload("res://Scenes/game_over.tscn").instantiate())
