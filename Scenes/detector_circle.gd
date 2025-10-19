class_name DetectorRing extends Node2D

static var circleSpeed:=200
const gradient:=preload("res://assets/detector_circle_gradient.tres")
const widthCurve:=preload("res://assets/detector_circle_width_curve.tres")
var currentRadius:=0.0
var maxDistance:float


func _draw() -> void:
	draw_circle(Vector2.ZERO,currentRadius,gradient.sample(maxDistance/500),false,widthCurve.sample(currentRadius/maxDistance),true)

func _process(delta: float) -> void:
	currentRadius+=circleSpeed*delta
	if currentRadius>maxDistance:
		queue_free()
	queue_redraw()
