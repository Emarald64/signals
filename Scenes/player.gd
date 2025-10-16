extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	if get_parent().getTresure().global_position.distance_squared_to(global_position)<1024:
		print('got tresure')
	velocity=Input.get_vector("move_left","move_right","move_up","move_down")*SPEED
	move_and_slide()


func spawnCircle() -> void:
	var circle =preload("res://Scenes/detector_circle.tscn").instantiate()
	circle.maxDistance=minf(500.0,get_parent().getTresure().global_position.distance_to(global_position))
	circle.position=position
	get_parent().add_child(circle)
