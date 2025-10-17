extends CharacterBody2D

#@export var curve:Curve
const SPEED = 300.0
@export_range(0,1.0,0.01) var randomness:=0.33
var animating:=false

func _physics_process(delta: float) -> void:
	velocity=Input.get_vector("move_left","move_right","move_up","move_down")*SPEED
	move_and_slide()


func spawnCircle() -> void:
	var circle =preload("res://Scenes/detector_circle.tscn").instantiate()
	circle.maxDistance=getCircleDistance()
	circle.position=position
	get_parent().add_child(circle)

func getCircleDistance() -> float:
	# get distance to closest tresure
	var minDistance:=10000000
	for tresure in get_parent().tresures:
		var distanceSquared=global_position.distance_squared_to(tresure.global_position)
		minDistance=min(distanceSquared,minDistance)
	return minf(500.0,(minDistance**0.5)/((cos(PI*randf())*randomness)+1))


func testCollectTresure(area: Area2D) -> void:
	$RayCast2D.target_position=area.global_position-global_position
	$RayCast2D.force_raycast_update()
	if not $RayCast2D.is_colliding():
		get_parent().collectedTresure(area)
		print('got tresure')
	else:
		print('wall blocking collection')
